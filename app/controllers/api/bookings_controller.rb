class Api::BookingsController < Api::ApplicationController
  before_action :authenticate_user_from_token!
  before_action :set_booking, only: [:destroy, :show]

  def show
    render json: @booking
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)
    @tour = Tour.find params[:tour_id]
    if @tour.seats >= @booking.no_of_seats && @booking.no_of_seats > 0
      @booking.user_id = @user.id
      @booking.tour_id = @tour.id
      @booking.payment_status = false
      @booking.payment_amount = @tour.price * @booking.no_of_seats
      if @booking.save
        @tour.seats = @tour.seats - @booking.no_of_seats
        @tour.save
        render json: @user
      else
        render :json => @booking.errors
      end
    else
      render json: {status: "Invalid Seat Numbers"}
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    if !@booking.payment_status
      @booking.destroy
      render json: {status: "Object Deleted"}
    else
      render json: {status: "You've paid for this booking"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.permit(:no_of_seats)
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
