# encoding: utf-8

# Bastardized RubyProf printer to print out JSON string.
module ProfileAction
  class JsonPrinter < RubyProf::AbstractPrinter
    def initialize(result)
      super(result)
      @array = []
    end

    def print(output = STDOUT, options = {})
      super(output, options)
      if @output.is_a?(Hash)
        @array << { 'profiled': @output }
        @output = json
      else
        @output.puts json
      end
    end

    def print_thread(thread)
      print_header(thread)
      print_methods(thread)
    end

    # Override for this printer to sort by self time by default
    def sort_method
      @options[:sort_method] || :self_time
    end

    private

    def json
      ProfileAction.configuration.pretty_json == true ? JSON.pretty_generate(@array) : JSON.dump(@array)
    end

    def print_header(thread)
      hash = {
        'Measure Mode' => "%s" % RubyProf.measure_mode_string,
        'Thread ID' => "%d" % thread.id,
        'Total' => "%0.6f" % thread.total_time,
        'Sort by' => sort_method
      }
      hash['Fiber ID'] = "%d" % thread.fiber_id unless thread.id == thread.fiber_id
      @array << {'header' => hash}
    end

    def print_methods(thread)
      total_time = thread.total_time
      methods = thread.methods.sort_by(&sort_method).reverse
      arr = []

      sum = 0
      methods.each do |method|
        self_percent = (method.self_time / total_time) * 100
        next if self_percent < min_percent

        sum += method.self_time

        arr << {
          '%self' => "%0.2f" % [method.self_time / total_time * 100],
          'total' => "%0.3f" % [method.total_time],
          'self' => "%0.3f" % [method.self_time],
          'wait' => "%0.3f" % [method.wait_time],
          'children_time' => "%0.3f" % [method.children_time],
          'calls' => "%8d" % [method.called],
          'cycle' => method.recursive? ? "*" : " ",
          'name' => method_name(method)
        }
      end
      @array << {'methods' => arr} if arr.length > 0
    end
  end
end
