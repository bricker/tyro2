Then /^there should be (\d) emails?$/ do |email_count|
  ActionMailer::Base.deliveries.count.should eq(email_count)
end