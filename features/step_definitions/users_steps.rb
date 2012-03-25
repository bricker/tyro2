#### Setup
Given /^(?:a )?users? with the following attributes?:$/ do |table|
  table.hashes.each do |attributes|
    create :user, attributes
  end
  all_users = User.all
  @user = all_users[rand(all_users.length)]
end


#### Routing
When /^I go to the cp users page$/ do
  visit cp_users_path
end

When /^I go to the new cp user page$/ do
  visit new_cp_user_path
end

When /^I go to (?:that|a|any) user's edit page$/ do
  visit edit_cp_user_path @user
end


#### Assertions
Then /^there should be (\d+) e\-mails? sent$/ do |num|
  ActionMailer::Base.deliveries.length.should eq num.to_i
end

Then /^the last e\-mail sent should be to that user$/ do
  last_email.to.should eq @user.email
end













# Given /^a user$/ do
#   @new_user = Factory(:user)
# end
# 
# Given /^a user with ([\w ]+) "([^\"]*)"$/ do |uattr, value|
#   @new_user = Factory(:user, uattr => value)
# end
# 
# Given /^I am a user$/ do
#   @me = Factory(:user)
# end
# 
# Given /^I am a user with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
#   user = Factory(:user, :email => email)
# end
# 
# Then /^the ([\w ]+) should have user "([^\"]*)"$/ do |record, name|
#   record.gsub(/\s/, "_").classify.constantize.first.users.first.name.should eq(name)
# end
# 
# Then /^the user should have no email$/ do
#   @new_user.email.should eq(nil)
# end
# 
# Then /^the user should be soft-deleted$/ do
#   @new_user.deleted_at.should_not eq(nil)
# end
# 
# Given /^I do not have the permission to "(.+)"$/ do |permission|
#   @user.permissions.delete Permission.find_by_title(permission)
# end