require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    if Rails.env.production?
      puts "--- CHECKING ENV VARS ON RENDER ---"
      puts "LINKEDIN_CLIENT_ID is present? #{ENV['LINKEDIN_CLIENT_ID'].present?}"
      puts "LINKEDIN_CLIENT_SECRET is present? #{ENV['LINKEDIN_CLIENT_SECRET'].present?}"
      puts "-------------------------------------"
    end

    # Add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    config.autoload_lib(ignore: %w[assets tasks])

    config.active_job.queue_adapter = :good_job

    # Configure OmniAuth middleware
   
  end
end
