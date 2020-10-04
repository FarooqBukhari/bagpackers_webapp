class Api::TourDetailsController < Api::ApplicationController
  before_action :authenticate_user_from_token!
  before_action :set_tour_detail, only: [:show, :update, :destroy]

  # GET /tour_details/1
  # GET /tour_details/1.json
  def show
  end


  # PATCH/PUT /tour_details/1
  # PATCH/PUT /tour_details/1.json
  def update
      @tour_detail.update(tour_detail_params)
      render json: @tour_detail
  end

  # DELETE /tour_details/1
  # DELETE /tour_details/1.json
  def destroy
    @tour_detail.destroy
  end

  private

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

    # Use callbacks to share common setup or constraints between actions.
    def set_tour_detail
      @tour_detail = TourDetail.find(params[:id])
      params.delete :id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_detail_params
      params.permit(:day,:location, :description, :email, :user_token, :id, :tour_id)
    end
end
