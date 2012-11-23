# Cardoon

This is sort of an experiment to bring the great documentating and
abstracting feature of [cucumber](http://cukes.info) to plain [rspec](https://www.relishapp.com/rspec).

Two most popular ways of doing integration testing in ruby world is to use cucumber or
request specs with Capybara (features actually in Capybara 2.0).
Cucumber has really nice outline of the features of your application but it is tedious to manage scenarios and steps.
Even more when your client is not taking part in writing features process.
Rspec on the other hand is easier to managa but the level of abstraction can be too low.

The idea is that you use steps inside of the example. The step is a method that accepts a description and block
which is the step's definition.
The advantage is apparent when using capybara features and having long scenarios.
In that case the intention of code can be hard to track down.
With steps you have the description and code in one place.

## Installation

Add this line to your application's Gemfile:

    gem 'cardoon', :git => 'git://github.com/asok/cardoon.git'

And then execute:

    $ bundle

## Usage

### Capybara

Let's say you have a Capybara feature like this:

```ruby
feature %Q{In order to add a new stuffed animal.
  As an admin of Chuck Testa warehouse application.
  I want to be able to add a new item.} do
  scenario 'Failing to add new item due to wrong user and size' do
    me = create(:admin)
    visit new_session_path
    fill_in 'session_login', :with => me.login
    fill_in 'session_password', :with => me.password
    click_button 'Login'
    visit items_path
    click_button 'New item'
    fill_in 'name', :with => 'Stuffed Capybara'
    fill_in 'item_width', width: witdth
    fill_in 'item_depth', width: depth
    fill_in 'item_height', width: height
    select 'Mammalia', :from => 'item_class' 
    select 'Caviidae', :from => 'item_family' 
    select species = 'Hydrochoerus hydrochaeris', :from => 'item_species' 
    select user = 'Chuck Testa', :from => 'item_user_id'
    click_button 'Create'
    page.should have_content("#{user} is allergic to #{species}. Item is too high.")
    Item.count.should == 0
  end
end
```

You can use steps to be more precise what you're actually doing:

```ruby
feature %Q{In order to add a new stuffed animal.
  As an admin of Chuck Testa warehouse application.
  I want to be able to add a new item.} do
  scenario 'Failing to add new item due to wrong user and size' do
    Given('I login as an admin'){
      me = create(:admin)
      visit new_session_path
      fill_in 'session_login', :with => me.login
      fill_in 'session_password', :with => me.password
      click_button 'Login'
    }
    When('I go to the new item page'){
      visit items_path
      click_button 'New item'
    }
    And('I define new item named %s', 'Stuffed Capybara'){ |name|
      fill_in 'name', :with => name
    }
    And('I specify size to %s x %s x %s', '30cm', '80cm', '60cm'){ |width, depth, height| 
      fill_in 'item_width', width: witdth
      fill_in 'item_depth', width: depth
      fill_in 'item_height', width: height
    }
    And('I specify its classification to %s > %s > %s',
        'Mammalia', 'Caviidae', 'Hydrochoerus hydrochaeris'){ |klass, family, species|
      select klass, :from => 'item_class' 
      select family, :from => 'item_family' 
      select @species = species, :from => 'item_species' 
    }
    And('assign %s to it', 'Chuck Testa'){ |user|
      select @user = user, :from => 'item_user_id'
    }
    And('I post'){
      click_button 'Create'
    }
    Then('I should see error message "%s"', "#{@user} is allergic to #{@species}. Item is to high."){ |msg|
      within('#error') do
        page.should have_content(msg)
      end
    }
    And('no item should be created'){
      Item.count.should == 0
    }
  end
end
```

If you run rspec with `Steps` formatter you will see the steps in the output:
```
  In order to add a new stuffed animal.
  As an admin of Chuck Testa warehouse application.
  I want to be able to add a new item.
    Failing to add new item due to wrong user and size
      Given I login as an admin
      When I go to the new item page
      And I define new item named Stuffed Capybara
      And I specify size to 30cm x 80cm x 60cm
      And I specify its classification to Mammalia > Caviidae > Hydrochoerus hydrochaeris
      And assign Chuck Testa to it
      And I post
      Then I should see error message "Chuck Testa is allergic to Hydrochoerus hydrochaeris. Item is to high."
      And no item should be created
```

To do this you can run rspec like that:
```
rspec --color --format Cardoon::Steps
```

Or put this in your `.rspec` configuration file:
```
--color
--format Steps
```

### Plain rspec

It will work with plain rspec too:

```ruby
describe "Fixnum#+" do
  it 'adds two fixnums' do
    When('I add "%s" to "%s', 1, 1) { |x, y|
      @z = x + y
    }
    Then('I will receive "%s"', 2) { |z|
      @z.should == z
    }
  end
end
```

## Alternatives

  * [rspec-example_steps](https://github.com/railsware/rspec-example_steps) - this is in fact the same idea though the implementation is slightly different. Cardoon expects you to explicitly specify Steps formatter to use in order to receive steps descriptions in the output.
  * [rspec-given](https://github.com/jimweirich/rspec-given)
  * [rspec-steps](https://github.com/LRDesign/rspec-steps)

## Ideas
  * `Steps` formatter inherits from rspec's `DocumentationFormatter`. Might we worth investigating some other approach to
  obtain better output

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please try to include a feature or scenario covering your change.

## Desclaimer

No capybara was hurt during development of this software.
