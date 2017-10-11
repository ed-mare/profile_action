require 'ruby-prof'
require 'ruby_prof-json'
require 'logger'

require 'profile_action/engine'
require 'profile_action/configuration'
require 'profile_action/controller/profile'

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
