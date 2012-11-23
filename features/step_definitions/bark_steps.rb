When /^I run rspec with ([\w:]+) format$/ do |format|
  step %Q{I run `rspec fixnum_spec.rb --require '#{File.dirname(__FILE__)}/../support/runner.rb' --format #{format}`}
end
