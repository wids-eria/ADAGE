Given /^a logged in admin$/ do
  @user = Fabricate :user

  visit new_user_session_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Sign in'
end

Given /^I am on the mass user form$/ do
  visit new_sequence_users_path
end

When /^I create "([^"]*)" users with prefix "([^"]*)" and start value "([^"]*)"$/ do |count, prefix, start_value|
  @original_count = User.count
  @sequence_prefix = prefix
  @sequence_count = count.to_i
  @sequence_start_value = start_value
  fill_in 'Prefix', with: prefix
  fill_in 'Count', with: count
  fill_in 'Start value', with: start_value
  fill_in 'Password', with: 'pass1234'
  click_button 'Create users'
end

Then /^I should have users$/ do
  @users = User.limit(@sequence_count).order("id desc").all
  User.count.should == @sequence_count + @original_count
end

Then /^I should be at the homepage$/ do
  current_path = URI.parse(current_url).path
  current_path.should == root_path
end

Then /^I should be at the users index$/ do
  current_path = URI.parse(current_url).path
  current_path.should == users_path
end

When /^I am on the user index$/ do
  visit users_path
end

Then /^I should see the users$/ do
  page.should have_content(User.last.email)
end
