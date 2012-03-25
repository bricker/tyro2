source 'http://rubygems.org'

gem 'rails', '3.2.2'
gem 'paperclip'
gem 'jquery-rails'
gem "chronic"
gem 'mysql2'
gem 'bcrypt-ruby'
gem 'whenever', :require => false
gem 'thinking-sphinx', '2.0.5'
gem 'rails_autolink'

gem "mediaelement_rails", :git => "git://github.com/tobsch/mediaelement_rails.git"
gem 'spinjs-rails'

gem 'unread', :git => 'https://github.com/ledermann/unread.git'
gem 'kaminari'
gem 'delayed_job', :git => 'https://github.com/collectiveidea/delayed_job.git'

gem 'capistrano'
gem 'capistrano-ext'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'twitter-bootstrap-rails'
end

group :production do
  gem 'therubyracer'
  gem 'rake' # So it's in the bundled gems, because I'm afraid of Dreamhost.
end

group :test, :development do
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'guard'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'launchy' 
  gem 'rb-fsevent', :require => false
end

group :test do
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'cucumber'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'fakeweb'
end
