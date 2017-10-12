module ProfileAction
  module Profile
    private

    def profile
      if config.profile == true
        method_result = nil
        result = RubyProf.profile { method_result = yield }
        caller = respond_to?(:action_name) ? action_name : caller_locations.first.label
        config.logger.send(
          config.log_level,
          config.json_output? ? jsonify(result, caller) : stringify(result, caller)
        )
        method_result
      else
        yield
      end
    end

    protected

    def jsonify(result, caller)
      ProfileAction::JsonPrinter.new(result).print(
        { 'class' => self.class, 'method' => caller },
        min_percent: config.min_percent
      )
    end

    def stringify(result, caller)
      output = "\nClass: #{self.class}, Method: #{caller}\n"
      RubyProf::FlatPrinter.new(result).print(
        output,
        min_percent: config.min_percent
      )
      output
    end

    def config
      ProfileAction.configuration
    end
  end
end
