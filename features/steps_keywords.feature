Feature: steps keywords outputted in a smart way

  In order to make the output more human readable
  As a Bard user
  I want to be able to repeat the same step keyword
  one after another but I expect to see 'And' keyword
  in the corresponding places in the output

Scenario: Printing steps with repeated 'Given' and with 'But' keyword
  Given a file named "fixnum_spec.rb" with:
    """
    require 'cardoon'

    describe 'Fixnum#+=', :capybara_feature => true do
      specify 'I can add a Fixnum to a Fixnum' do
        Given 'I set x to 1' do
          @x = 1
        end
        Given 'I set y to 1' do
          @y = 1
        end
        When 'I use #+= on x' do
          @x += @y
        end
        Then 'x will 2' do
          @x.should == 2
        end
        But 'y will be 1' do
          @y.should == 1
        end
      end
    end
    """
  When I run rspec with Cardoon::Steps format
  Then the output should contain:
    """
    Fixnum#+=
      I can add a Fixnum to a Fixnum
        Given I set x to 1
        And I set y to 1
        When I use #+= on x
        Then x will 2
        But y will be 1
    """
