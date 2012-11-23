require 'cardoon/steps'
require 'cardoon/steps_methods'

RSpec.configuration.include Cardoon::StepsMethods, :capybara_feature => true
