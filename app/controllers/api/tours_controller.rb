class Api::ToursController < Api::ApplicationController
  before_action :authenticate_user_from_token!
  before_action :set_tour, only: [:update, :destroy, :show]

  def index
    @tours = Tour.all
    if @tours.count > 0
      render json: @tours
    end
  end


  def show
    render json: @tour
  end

  # token = Doorkeeper::AccessToken.where(token: 'oI-HDApnzgkSebZsClOuXovNSvKbMFF0U7yrNl5J9a4')
  # user  = User.find(token[0].resource_owner_id)
  # send access token in body params on every request if authorization is required

  def create
    if !@user.trip_organizer.nil?
      @tour = Tour.new(tour_params)
      @tour.trip_organizer_id = @user.trip_organizer.id

        if @tour.save
          @tour_details = []
          @tour.duration.times  do  |index|
            @tour_details[index] = TourDetail.new
            @tour_details[index].day = index
          end

          @tour.tour_details << @tour_details

          render json: @tour
        else
          render json: @tour.errors, status: :unprocessable_entity
        end
    else
        render json: {status: 'failed'}
    end
    end

  def update
    if @tour.trip_organizer_id = @user.trip_organizer.id
      if @tour.update(tour_params)
        render json: @tour
      else
        render json: @tour.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @tour.trip_organizer_id = @user.trip_organizer.id

      @tour.destroy
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



  def tour_params
    params.permit(:title, :price, :date, :duration, :seats, :image, :email, :user_token, :id, trip_images:[])
  end

  private

  def set_tour
    @tour = Tour.find(params[:id])
    params.delete :id
  end

end
