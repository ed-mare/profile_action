require 'spec_helper'
require 'fileutils'

class TestClass
  include ProfileAction::Profile

  def method_a
    profile do
      (1..100).reduce { |sum, v| sum + v }
    end
  end

  def method_b
    result = profile do
      (1..100).reduce { |sum, v| sum + v }
    end
    result + 1000
  end
end

describe ProfileAction::Profile do
  describe '#profile' do
    let(:instance) { TestClass.new }

    it 'returns the methods value (example #1)' do
      expect(instance.method_a).to eq(5050)
    end

    it 'returns the methods value (example #2)' do
      expect(instance.method_b).to eq(6050)
    end

    context 'with stdout logger' do
      context 'with text output' do
        it 'writes FlatPrinter as text' do
          expect { instance.method_a }.to output(/Sort by: self_time/).to_stdout_from_any_process
          expect { instance.method_a }.to output(/Range#each/).to_stdout_from_any_process
          expect { instance.method_a }.to output(/Enumerable#reduce/).to_stdout_from_any_process
          expect { instance.method_a }.to output(/ProfileAction::Profile#profile/).to_stdout_from_any_process
          expect { instance.method_a }.to output(/Class: TestClass, Method: method_a/).to_stdout_from_any_process
        end
      end

      context 'with json output' do
        before(:all) { ProfileAction.configuration.print_json = true }
        after(:all) {  ProfileAction.configuration.print_json = false }

        it 'writes FlatPrinter as JSON' do
          expect { instance.method_a }.to output(/"Sort by":"self_time"/).to_stdout_from_any_process
          expect { instance.method_a }.to output(/"name":"Range#each"/).to_stdout_from_any_process
          expect { instance.method_a }.to output(/"wait":"0.000"/).to_stdout_from_any_process
          expect { instance.method_a }.to output(/{"class":"TestClass","method":"method_a"}/).to_stdout_from_any_process
        end
      end
    end

    context 'with file-based logger' do
      def log_contents
        IO.read(logger_file_path)
      end

      let(:logger_file_path) { File.absolute_path('spec/fixtures/test.log') }
      before(:each) do
        ProfileAction.configuration.logger = Logger.new(logger_file_path)
      end
      after(:each) do
        FileUtils.rm(logger_file_path) if File.exist?(logger_file_path)
      end

      context 'with text output' do
        it 'writes FlatPrinter as text' do
          instance.method_a
          contents = log_contents
          expect(contents).to match(/1\s+Range#each/)
          expect(contents).to match(/Enumerable#reduce/)
          expect(contents).to match(/ProfileAction::Profile#profile/)
          expect(contents).to match(/Class: TestClass, Method: method_a/)
        end
      end

      context 'with json output' do
        before(:all) { ProfileAction.configuration.print_json = true }
        after(:all) { ProfileAction.configuration.print_json = false }

        it 'writes FlatPrinter as json' do
          instance.method_a
          contents = log_contents
          expect(contents).to match(/"Sort by":"self_time"/)
          expect(contents).to match(/"name":"Range#each"/)
          expect(contents).to match(/"wait":"0.000"/)
          expect(contents).to match(/{"class":"TestClass","method":"method_a"}/)
        end
      end
    end
  end
end
