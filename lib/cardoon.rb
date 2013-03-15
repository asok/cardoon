require 'cardoon/steps'
require 'cardoon/steps_methods'

RSpec.configuration.include Cardoon::StepsMethods, :capybara_feature => true

if Gem::Version.new(RSpec::Core::Version::STRING) <= Gem::Version.new("2.12.0")
  class Cardoon::Steps
    def success_color(text)
      green(text)
    end

    def failure_color(text)
      red(text)
    end
  end
end
