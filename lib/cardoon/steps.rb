require 'rspec/core/formatters/documentation_formatter'

module Cardoon
  class Steps < RSpec::Core::Formatters::BaseTextFormatter
    def initialize(output)
      super
      @group_level = 0
      @last_keyword = ''
      @steps = {}
    end

    def __step__(keyword, description, example)
      @steps[example] ||= []
      @steps[example] << "#{keyword == @last_keyword ? 'And' : keyword} #{description}"
      @last_keyword = keyword
    end

    def example_passed(example)
      super

      message = description_output(example)
      example_steps = @steps.delete(example)
      if example_steps
        output.puts message
        output_steps(example_steps, :green)
      else
        output.puts green(message)
      end
    end

    def example_failed(example)
      super

      message = "#{description_output(example)} (FAILED - #{next_failure_index})"
      if example_steps = @steps.delete(example)
        output.puts message
        output_steps(example_steps[0...-1], :green)
        output_steps(example_steps[-1..-1], :red)
      else
        output.puts red(message)
      end
    end

    def example_group_started(example_group)
      super

      output.puts if @group_level == 0
      output.puts description_output(example_group)

      @group_level += 1
    end

    def example_group_finished(_)
      @group_level -= 1
    end

    def example_pending(example)
      super

      output.puts yellow("#{description_output(example)} (PENDING: #{example.execution_result[:pending_message]})")
    end

    protected

    def output_steps(steps, color)
      steps.each{ |step| output.puts send(color, "#{current_indentation}  #{step}") }
    end

    def current_indentation
      short_padding * @group_level
    end

    def description_output(example)
      "#{current_indentation}#{example.description.strip}"
    end

    def next_failure_index
      @next_failure_index ||= 0
      @next_failure_index += 1
    end
  end
end
