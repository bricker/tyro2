When /^I submit the form$/ do
  find('input[type=submit]').click
end

Then /^I should be on the cp root page$/ do
  current_path.should eq cp_root_path
end

Then /^I should see a success message$/ do
  page.should have_css('#flash_messages .notice')
end

Then /^I should see an alert message$/ do
  page.should have_css('#flash_messages .alert')
end