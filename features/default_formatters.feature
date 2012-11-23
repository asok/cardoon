Feature: using default rspec formatters

  In order to use Cardoon without Step formatter
  As a Cardoon user
  I want to be able to use the default Rspec formatters

Background:
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
  
Scenario: Using progress format
  When I run rspec with progress format
  Then the output should contain:
    """
    .
    """

Scenario: Using documentation format
  When I run rspec with documentation format
  Then the output should contain:
    """
    Fixnum#+
      I can add a Fixnum to a Fixnum
    """
