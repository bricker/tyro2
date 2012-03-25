When /^I go to the cp root page$/ do
  visit cp_root_path
end

When /^I follow "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be notified of errors$/ do
  page.should have_css "#flash .alert"
end

When /^I follow "([^"]*)" in the sub\-nav$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I check "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

# Given /^the following (.+) records?$/ do |factory, table|
#   table.hashes.each do |hash|
#     Factory(factory, hash)
#   end 
# end
# 
# Then /^there should be ([0-9]+) ([\w ]+)$/ do |count, record|
#   record.gsub(/\s/, "_").classify.constantize.count.should == count.to_i
# end
# 
# # clean this up.
# Given /^a special event$/ do
#   @special_event = Factory(:special_event)
# end
# 
# Then /^I should see the title of the event$/ do
#   page.should have_content(@special_event.title)
# end
# 