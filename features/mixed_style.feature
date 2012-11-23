Feature: using mixed style

  For the sake of usability
  As a Cardoon user
  I want to be able to place my code in the step methods
  and outside of them within an example

Scenario: Placing code in the step methods and outside of them
  Given a file named "fixnum_spec.rb" with:
    """
    require 'cardoon'

    describe 'Fixnum#-', :capybara_feature => true do
      specify 'I can substract a Fixnum from a Fixnum' do
        Given 'I set x to 1' do
          @x = 1
        end
        When 'I substract 1 from it' do
          @x = @x - 1
        end
        @x.should == 0
      end
    end
    """
  When I run rspec with Cardoon::Steps format
  Then the output should contain:
    """
    Fixnum#-
      I can substract a Fixnum from a Fixnum
        Given I set x to 1
        When I substract 1 from it
    """

Scenario: Omitting step methods entirely
  Given a file named "fixnum_spec.rb" with:
    """
    require 'cardoon'

    describe 'Fixnum#-', :capybara_feature => true do
      specify 'I can substract a Fixnum from a Fixnum' do
        x = 1
        x = x - 1
        x.should == 0
      end
    end
    """
  When I run rspec with Cardoon::Steps format
  Then the output should contain:
    """
    Fixnum#-
      I can substract a Fixnum from a Fixnum
    """
