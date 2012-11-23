Feature: signaling pass and fail

  In order to know if the example passed or not
  As a Cardoon user
  I want to be able to see it from the output and
  in a case of a failure I want to know
  in which step the error occured

Scenario: Printing steps of an example that passed
  Given a file named "fixnum_spec.rb" with:
    """
    require 'cardoon'

    describe 'Fixnum#+', :capybara_feature => true do
      specify 'I can add a Fixnum to a Fixnum' do
        Given 'I set x to 1' do
          @x = 1
        end
        When 'I add 1 to it' do
          @x = @x + 1
        end
        Then 'x will be 2' do
          @x.should == 2
        end
      end
    end
    """
  When I run rspec with Cardoon::Steps format
  Then the output should contain:
    """
    Fixnum#+
      I can add a Fixnum to a Fixnum
        Given I set x to 1
        When I add 1 to it
        Then x will be 2
    """

Scenario: Printing steps of an example that failed
  Given a file named "fixnum_spec.rb" with:
    """
    require 'cardoon'

    describe 'Fixnum#/', :capybara_feature => true do
      specify 'I cannot divide a Fixnum by 0' do
        Given 'I set x to 1' do
          @x = 1
        end
        When 'I try to divide x by 0' do
          @x/0
        end
        Then 'this step will never happen' do
          @x.should == 1
        end
      end
    end
    """
  When I run rspec with Cardoon::Steps format
  Then the output should contain:
    """
    Fixnum#/
      I cannot divide a Fixnum by 0 (FAILED - 1)
        Given I set x to 1
        When I try to divide x by 0
    """
  And the output should not contain:
  """
  Then this step will never happen
  """
