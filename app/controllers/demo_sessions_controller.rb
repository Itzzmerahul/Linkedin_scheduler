class DemoSessionsController < ApplicationController
  def create
    # Find or create a demo user
    user = User.find_or_create_by(email: "demo@example.com") do |u|
      u.name = "Demo User"
      u.provider = "developer"
      u.uid = "12345"
    end

    # Log the user in
    session[:user_id] = user.id
    redirect_to root_path, notice: "Successfully logged in as Demo User!"
  end
end