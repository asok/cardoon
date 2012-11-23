Feature: substitutions in the step's description

  In order to make each step more self-explanatory
  As a Cardoon user
  I want to be able to use variables in the step's description
  and definition

Scenario: Printing steps with substitutions
  Given a file named "fixnum_spec.rb" with:
    """
    require 'cardoon'

    describe 'Fixnum#*', :capybara_feature => true do
      specify 'I can multiply a Fixnum with a Fixnum' do
        When('I multiply "%s" by "%s"', 2, 2) do |x, y|
          @z = x*y
        end
        Then('I will get "%s"', 4) do |result|
          @z.should == result
        end
      end
    end
    """
  When I run rspec with Cardoon::Steps format
  Then the output should contain:
    """
    Fixnum#*
      I can multiply a Fixnum with a Fixnum
        When I multiply "2" by "2"
        Then I will get "4"
    """
