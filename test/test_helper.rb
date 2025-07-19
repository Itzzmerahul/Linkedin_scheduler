ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Log in a user via OmniAuth in tests
    def login_as(user)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
        provider: 'linkedin',
        uid: user.uid,
        info: {
          name: user.name,
          email: user.email
        },
        credentials: {
          token: "test-token",
          expires_at: 1.week.from_now.to_i
        }
      })

      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:linkedin]

      # Perform the callback to actually set session
      get '/auth/linkedin/callback'
    end
  end
end
