#### Setup
Given /^I have the following permissions?:$/ do |table|
  table.hashes.each do |attributes|
    @current_user.permissions << create(:permission, :title => attributes["permission"])
  end
  @current_user.permissions.count.should eq table.hashes.length
end

Given /^I have no permissions$/ do
  @user.permissions.clear
end