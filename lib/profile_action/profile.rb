module ProfileAction # :nodoc:
  # == Mixin
  #
  # Provides a mixin method for profiling controller actions or any instance methods.
  #
  # === Example:
  #
  #   class ItemsController < Api::BaseController
  #     include ProfileAction::Profile
  #     around_action :profile, only: :index
  #   end
  #
  #   # It can also be used to profile methods or parts of instance methods.
  #
  #   def method_a
  #     profile do
  #       (1..100).reduce { |sum, v| sum + v }
  #     end
  #   end
  #
  #   def method_b
  #     data = profile do
  #       fetch_data_from_service
  #     end
  #     save_to_database(data)
  #   end
  #
  module Profile
    protected

    def profile
      if config.profile == true
        method_result = nil
        result = RubyProf.profile { method_result = yield }
        caller = respond_to?(:action_name) ? action_name : caller_locations(1..1).first.label
        config.logger.send(
          config.log_level,
          config.json_output? ? jsonify(result, caller) : stringify(result, caller)
        )
        method_result
      else
        yield
      end
    end

    private

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
