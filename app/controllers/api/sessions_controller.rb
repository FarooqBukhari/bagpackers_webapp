class Api::SessionsController < Devise::SessionsController

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

prepend_before_action :require_no_authentication, :only => [:create]
  before_action :ensure_params_exist, only: :create

  respond_to :json

  def create
    user = User.find_by(:email => params[:email])
    unless user.nil?
               if user.valid_password? params[:password]
               render :json => user
               return
               end
    end
    render :json => '{"error": "invalid email and password combination"}'
  end

  def destroy
    sign_out(resource_name)
  end

  protected
  def ensure_params_exist
    return unless params[:email].blank?
    render :json => {:success => false, :message => "missing user_login parameter"
    }, :status => 422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json => {:success => false, :message => "Error with your login or password"
    }, :status => 401
  end
end