module ProfileAction
  module Profile

    protected

    def profile
      if config.profile == true
        method_result = nil
        result = RubyProf.profile { method_result = yield }
        caller = caller_locations(1, 1)[0].label
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
