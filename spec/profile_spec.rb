require 'spec_helper'
require 'fileutils'

class TestClass
  include ProfileAction::Profile

  def method_a
    profile do
      (1..100).reduce{|sum, v| sum + v}

    end
  end
end

describe ProfileAction::Profile do

  describe '#profile' do
    let(:instance) { TestClass.new }

    # after(:each) do
    #   file = File.absolute_path('spec/fixtures/fred-oauth_token.pstore')
    #   FileUtils.rm(file) if File.exist?(file)
    # end

    context 'with default configs (STDOUT, text)' do

      it 'returns the methods value' do
        expect(instance.method_a).to eq(5050)
      end

      it 'writes FlatPrinter as string to default logger (STDOUT)' do
        instance.method_a
        expect { instance.method_a }.to output(/Sort by: self_time/).to_stdout_from_any_process
        expect { instance.method_a }.to output(/Range#each/).to_stdout_from_any_process
        expect { instance.method_a }.to output(/Enumerable#reduce/).to_stdout_from_any_process
        expect { instance.method_a }.to output(/ProfileAction::Profile#profile/).to_stdout_from_any_process
        expect { instance.method_a }.to output(/{"class"=>TestClass, "caller"=>"stringify"}/).to_stdout_from_any_process
      end

    end

    context 'with print_json = true' do

      before(:each) do
        ProfileAction.configuration.print_json = true
      end

      after(:each) do
        ProfileAction.configuration.print_json = false
      end

      it 'returns the methods value' do
        expect(instance.method_a).to eq(5050)
      end

      it 'writes FlatPrinter as JSON to default logger (STDOUT)' do
        instance.method_a
        expect { instance.method_a }.to output(/"Sort by":"self_time"/).to_stdout_from_any_process
        expect { instance.method_a }.to output(/"name":"Range#each"/).to_stdout_from_any_process
        expect { instance.method_a }.to output(/"wait":"0.000"/).to_stdout_from_any_process
      end

    end

    context 'with file logger' do

      before(:all) do
        FileUtils.touch('test.log')
        ProfileAction.configuration.logger = Logger.new('test.log')
        ProfileAction.configuration.print_json = true
      end
      after(:all) do
        ProfileAction.configuration.logger = Logger.new(STDOUT)
        File.delete('test.log')
        ProfileAction.configuration.print_json = false
      end

      it 'returns the methods value' do
        expect(instance.method_a).to eq(5050)
      end

      it 'writes FlatPrinter as text to file logger' do
        instance.method_a
        expect(File.open('test.log').grep(/Range#each/).length).not_to eq(0)
      end

    end

  end

end
