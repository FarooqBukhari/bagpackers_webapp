class Api::Users::RegistrationsController < Devise::RegistrationsController
    respond_to :json
    protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

    def create

      user = User.new(user_params)
      if user.save
          render json: user
        return
      else
        warden.custom_failure!
          render :json => user.errors, :status=>422
      end
    end

    private
    def user_params
      params.permit(:email,:password,:name)
    end
end