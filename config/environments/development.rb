FuturCadre::Application.configure do

  ActionMailer::Base.smtp_settings = {
      :address => "smtp.gmail.com",
      :port => "587",
      :domain => "gmail.com",
      :enable_starttls_auto => true,
      :authentication => :login,
      :user_name => "test.account.rac@gmail.com",
      :password => "racpakistan22"
  }

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options = {:host => 'ilsainteractive.com:3001'}

 #----------------- Active Merchant
 config.after_initialize do

    ActiveMerchant::Billing::Base.mode = :test
    ActiveMerchant::Billing::PaypalExpressGateway.default_currency = 'USD'
 end

 paypal_options = {
      :login => "ilsain_1291126914_biz_api1.ilsainteractive.com",
      :password => "1291126937",
      :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31AomsT22PGelbX17SMnveQXTK8WAT"
 }

 ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
 ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)

#-------------------------------------------------------------------------
end
