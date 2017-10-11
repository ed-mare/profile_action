require 'ruby-prof'
require 'logger'
require 'json'

require 'profile_action/json_printer'
require 'profile_action/configuration'
require 'profile_action/profile'

module ProfileAction
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.logger
    ProfileAction.configuration.logger
  end
end
