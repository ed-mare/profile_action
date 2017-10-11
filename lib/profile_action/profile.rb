module ProfileAction
  module Profile

    def profile
      if config.profile == true
        method_result = nil
        result = RubyProf.profile { method_result = yield }
        config.logger.send(
          config.log_level,
          config.json_output? ? jsonify(result) : stringify(result)
        )
        method_result
      else
        yield
      end
    end

    protected

    def jsonify(result)
      ProfileAction::JsonPrinter.new(result).print(
        caller_description,
        min_percent: config.min_percent
      )
    end

    def stringify(result)
      output = "#{caller_description.to_s}\n"
      RubyProf::FlatPrinter.new(result).print(
        output,
         min_percent: config.min_percent
      )
      output
    end

    def caller_description
      { 'class' => self.class, 'caller' => caller_locations(1, 1)[0].label }
    end

    def config
      ProfileAction.configuration
    end
  end
end
