require 'rubygems'
require 'cucumber/rails'
require Rails.root.join "spec/support/mailer_macros.rb"
require 'database_cleaner'
require 'database_cleaner/cucumber'
require 'cucumber/rspec/doubles'

Cucumber::Rails::Database.javascript_strategy = :truncation
include Factory::Syntax::Methods
include MailerMacros

Capybara.default_selector = :css
ActionController::Base.allow_rescue = false
DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

After do |scenario|
  DatabaseCleaner.clean
  reset_email  
end

