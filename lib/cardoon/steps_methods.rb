require 'rspec/core/formatters/base_formatter'

module Cardoon
  module StepsMethods
    def self.included(_)
      RSpec::Core::Formatters::BaseFormatter.class_eval <<-EVAL
        def __step__(*) ; end
      EVAL
    end

    [:Given, :When, :Then, :And, :But].each do |method_name|
      define_method method_name do |description, *step_args, &block|
        RSpec.world.reporter.notify(:__step__, method_name, description % step_args, example)
        block.call(*step_args) if block
      end
    end
  end
end
