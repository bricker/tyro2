When /^I fill in the form with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  fill_in 'email', :with => email
  fill_in 'password', :with => password
end

Given /^I have logged in$/ do
  @user = Factory(:user)
  visit cp_login_path
  fill_in 'email', :with => @user.email
  fill_in 'password', :with => 'secret'
  find('input[type=submit]').click
  current_path.should eq(cp_root_path)
end

# Given /^I have logged in with email "(.+)"$/ do |email|
#   @user = User.find_by_email(email)
#   visit cp_login_path
#   fill_in 'email', :with => email
#   fill_in 'password', :with => 'secret'
#   find('input[type=submit]').click
#   current_path.should eq(cp_root_path)
# end

Given /^I am on the login page$/ do
  visit cp_login_path
  current_path.should eq cp_login_path
end

Then /^my information should be displayed at the top$/ do
  page.should have_css "#log a.edit-link", :count => 3
end

Then /^I should be sent back to the login page$/ do
  page.should have_css "form#login"
end
