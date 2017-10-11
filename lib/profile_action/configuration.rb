module ProfileAction
  # == Gem Configurations
  #
  # === Example:
  #
  #   # in config/initializers/profile_action.rb
  #   ProfileAction.configure do |c|
  #     c.min_percent = 3
  #     c.print_json = true
  #     c.logger = Rails.logger
  #   end
  #
  class Configuration
    # true/false. Turns on/off profiling. Default is true (profiles).
    attr_accessor :profile

    # Integer. Rubyprof printer :min_percent. Number 0 to 100 that specifes the
    # minimum %self (the methods self time divided by the overall total time)
    # that a method must take for it to be printed out in the report. Defautls
    # to 0. https://github.com/ruby-prof/ruby-prof/blob/master/lib/ruby-prof/printers/abstract_printer.rb
    attr_accessor :min_percent

    # true/false. Print out JSON. Defaults to false. Prints out text table.
    attr_accessor :print_json

    # Defaults to Logger.new(STDOUT)
    attr_accessor :logger

    def initialize
      @profile = true
      @min_percent = 0
      @print_json = false
      @logger = Logger.new(STDOUT)
    end
  end
end
