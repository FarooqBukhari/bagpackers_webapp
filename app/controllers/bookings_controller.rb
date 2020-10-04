class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  def new_card
    respond_to do |format|
      format.js
    end
  end

  def create_card
     respond_to do |format|
      if current_user.stripe_id.nil?
        customer = Stripe::Customer.create({"email": current_user.email})
        #here we are creating a stripe customer with the help of the Stripe library and pass as parameter email.
        current_user.update(:stripe_id => customer.id)
        #we are updating current_user and giving to it stripe_id which is equal to id of customer on Stripe
      end
      card_token = params[:stripeToken]
      #it's the stripeToken that we added in the hidden input
      if card_token.nil?
        format.html { redirect_to user_path, error: "Oops"}
      end
      #checking if a card was giving.

      customer = Stripe::Customer.new current_user.stripe_id
      customer.source = card_token
      #we're attaching the card to the stripe customer
      customer.save

       format.html { redirect_to success_path }
     end
  end

  def success
  end

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)
    @tour = Tour.find params[:tour_id]
    if @booking.no_of_seats == 0
      flash.now[:danger] = "Number of seats booked are 0"
    end
    if @tour.seats >= @booking.no_of_seats && @booking.no_of_seats > 0
      @booking.user_id = current_user.id
      @booking.tour_id = @tour.id
      @booking.payment_status = false

      @booking.payment_amount = (@tour.promoted ? @tour.promotion_price : @tour.price) * @booking.no_of_seats

      if @booking.save
        @tour.seats = @tour.seats - @booking.no_of_seats
        @tour.save
        redirect_to new_charge_path(@booking.id), method: :post
      end
    else
      flash.now[:danger] = "Number of seats booked are more than total number of seats"
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    if !@booking.payment_status
      @booking.destroy
      respond_to do |format|
        format.html { redirect_to my_bookings_path(current_user), notice: 'Booking was successfully destroyed.' }
        format.json { head :no_content }
      end
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
end
