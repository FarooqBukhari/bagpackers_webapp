class Api::UsersController < ApplicationController
  before_action :authenticate_user_from_token!
  def show
    if !@user.nil?
      render json: @user
    end
  end


  def authenticate_user_from_token!
    user_email = params[:email].presence
    user = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      @user = User.find_by_email(user_email)
      params.delete :user_token
      params.delete :email
      return true
    else
      render :json => '{"success" : "false"}'
    end
  end
end
