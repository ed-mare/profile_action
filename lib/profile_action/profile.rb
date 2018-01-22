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
        exception = nil
        result = RubyProf.profile do
          # RubyProf 0.16 swallows exceptions => https://github.com/ruby-prof/ruby-prof/issues/220
          # so capture and re-raise. Disable rubocop rule; it's okay, Exception is re-raised.
          # rubocop:disable RescueException
          begin
            method_result = yield
          rescue Exception => ex
            exception = ex
          end
          # rubocop:enable RescueException
        end
        caller = respond_to?(:action_name) ? action_name : caller_locations(1..1).first.label
        config.logger.send(
          config.log_level,
          config.json_output? ? jsonify(result, caller) : stringify(result, caller)
        )
        exception.nil? ? method_result : raise(exception)
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
