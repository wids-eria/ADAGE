Given /^a logged in admin$/ do
  @user = Fabricate(:admin, roles: [Role.create(name: 'admin'), Role.create(name: 'player')])

  visit new_user_session_path
  fill_in 'Login', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Sign in'
end

Given /^a logged in player$/ do
  @user = Fabricate(:user, roles: [Role.create(name: 'player')])

  visit new_user_session_path
  fill_in 'Login', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Sign in'
end


Given /^I am on the mass user form$/ do
  visit new_sequence_users_path
end

Given /^some data$/ do
  @data = Fabricate(:AdaData)
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

Then /^I should be on my profile$/ do
  current_path = URI.parse(current_url).path
  current_path.should == profile_path
end

When /^I visit the user index$/ do
  visit users_path
end

When /^I visit the data index$/ do
  visit data_path
end

Then /^I should see the users$/ do
  page.should have_content(User.last.email)
end

Then /^I should see access denied message$/ do
  page.should have_content('You are not authorized to access this page')
end

Then /^I should see data$/ do
  page.should have_content(AdaData.last.id)
end

Then /^show me the page$/ do
  save_and_open_page
end
