module ProfileAction
  module Controller
    # Use an around_filter on an action to profile with RubyProf.
    #
    #   i.e., around_filter :profile, only: :my_action_here
    #
    # It outputs to STDOUT.
    def profile
      if config.profile == true
        result = RubyProf.profile { yield }
        printer.new(result).print(config.logger, min_percent: config.min_percent)
      else
        yield
      end
    end

    protected

    def printer
      config.print_json ? RubyProf::JsonPrinter : RubyProf::FlatPrinter
    end

    def config
      ProfileAction.configuration
    end
  end
end
