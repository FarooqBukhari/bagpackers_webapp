class Api::TripOrganizersController < Api::ApplicationController
  before_action :authenticate_user_from_token!
  before_action :set_trip_organizer, only: [:show, :update, :destroy]
  # GET /trip_organizers
  # GET /trip_organizers.json
  def index
    @trip_organizers = TripOrganizer.all
  end

  # GET /trip_organizers/1
  # GET /trip_organizers/1.json
  def show
    render json: @trip_organizer
  end

  # POST /trip_organizers
  # POST /trip_organizers.json
  def create
    @trip_organizer = TripOrganizer.new(trip_organizer_params)
    @trip_organizer.user_id = @user.id
      if @trip_organizer.save
        @user.is_trip_organizer = true
        @user.save
        render json: @trip_organizer
      else
        render json: @trip_organizer.errors, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /trip_organizers/1
  # PATCH/PUT /trip_organizers/1.json
  def update
      if @trip_organizer.update(trip_organizer_params)
        render json: @trip_organizer
      else
        render json: @trip_organizer.errors, status: :unprocessable_entity
      end
  end

  # DELETE /trip_organizers/1
  # DELETE /trip_organizers/1.json
  def destroy
    @trip_organizer.destroy
      format.json { head :no_content }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip_organizer
      @trip_organizer = TripOrganizer.where(user_id: @user.id)[0]
    end

    # # Never trust parameters from the scary internet, only allow the white list through.
    def trip_organizer_params
      params.permit(:company_name, :about, :address, :license, :user_token, :email, :company_email, :company_number, :terms, :company_logo)
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
