# config/initializers/omniauth.rb

# Monkey-patch the OmniAuth LinkedIn strategy to support the new OIDC flow.
# This is necessary because the gem is built for the older v2 API, but new
# LinkedIn apps can only use the new OIDC-compliant API.
class OmniAuth::Strategies::LinkedIn
  # 1. Define the correct endpoint for user data with OIDC.
  USER_INFO_URL = 'https://api.linkedin.com/v2/userinfo'.freeze

  # 2. Override the method that fetches user data.
  #    The original method calls '/v2/me', which is not available with OIDC scopes.
  #    We change it to call the correct USER_INFO_URL.
  def raw_info
    @raw_info ||= access_token.get(USER_INFO_URL).parsed
  end

  # 3. Override the info hash to map the OIDC fields correctly.
  #    The original method expects fields like 'firstName', which are not in the OIDC response.
  #    We map the new fields ('name', 'given_name', etc.) to the expected keys.
  info do
    {
      name: raw_info['name'],
      email: raw_info['email'],
      first_name: raw_info['given_name'],
      last_name: raw_info['family_name'],
      picture_url: raw_info['picture']
      # Note: public_profile_url is not available in the standard OIDC response
    }
  end

  # 4. Override the UID to use the 'sub' (subject) field from the OIDC response.
  #    This is the unique identifier for the user in the OIDC standard.
  uid { raw_info['sub'] }
end


# Now, configure the middleware with our patched strategy.
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin,
           '86nulgqb64smae',
           'WPL_AP1.Q27pFeMhjHlgxrtF.M/cmzQ==',
           scope: 'openid profile email'
end