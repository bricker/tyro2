Tyro::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false
  
  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  #config.action_controller.perform_caching = true
  #config.action_controller.cache_store = :file_store, "/tmp/cache/"

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false
  
  # Expands the lines which load the assets
  config.assets.debug = true
  
  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  config.action_mailer.delivery_method = :smtp
  
  ## omitted config settings here

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = false
  config.action_mailer.default_charset = 'utf-8'
  default_url_options[:host] = 'localhost:3000'
end
