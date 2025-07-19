class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']

    # Find an existing user or create a new one
    user = User.find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider']) do |u|
      u.name = auth_hash['info']['name']
      u.email = auth_hash['info']['email']
    end

    # Update the user's tokens and expiration on every login
    user.update(
      token: auth_hash['credentials']['token'],
      refresh_token: auth_hash['credentials']['refresh_token'],
      expires_at: Time.at(auth_hash['credentials']['expires_at'])
    )

    # Store the user's ID in the session to keep them logged in
    session[:user_id] = user.id

    # Redirect to the home page with a success message
    redirect_to root_path, notice: "Successfully logged in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out."
  end
end