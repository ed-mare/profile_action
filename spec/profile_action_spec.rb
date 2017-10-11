require 'spec_helper'

describe ProfileAction do
  it 'has a version number' do
    expect(ProfileAction::VERSION).not_to be nil
  end

  # describe '.token' do
  #
  #   after(:each) do
  #     file = File.absolute_path('spec/fixtures/fred-oauth_token.pstore')
  #     FileUtils.rm(file) if File.exist?(file)
  #   end
  #
  #   context 'with no cached token', vcr: true do
  #
  #     it 'fetches the token from the auth server' do
  #       token = AppsIt::OauthClient::token(fred_app_key)
  #       expect(token).to_not be(nil)
  #       expect(token.access_token).to be_kind_of(String)
  #       expect(token.expires_in).to be_kind_of(Fixnum)
  #       expect(token.created_at).to be_kind_of(Fixnum)
  #     end
  #
  #   end
  #
  # end
end
