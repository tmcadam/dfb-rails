require_relative 'boot'

require 'rails/all'
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DfbRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.assets.css_compressor = :yui
    config.assets.js_compressor = :uglifier

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_caching = false
    config.action_mailer.smtp_settings = {
        :address              => ENV["SMTP_HOST"],
        :domain               => ENV["SMTP_DOMAIN"],
        :port                 => ENV["SMTP_PORT"].to_i,
        :user_name            => ENV["SMTP_USER"],
        :password             => ENV["SMTP_PASS"],
        :authentication       => :login,
        :enable_starttls_auto => true
    }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
