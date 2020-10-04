class Dashboard::TripOrganizersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip_organizer
  before_action :is_trip_organizer?
  # GET /trip_organizers
  # GET /trip_organizers.json
  def index
    @tour = Tour.new
    @tours = @trip_organizer.tours.order(created_at: :desc)
    @tour_reviews = @trip_organizer.tour_reviews.eager_load(:user, :tour).order(created_at: :desc)
    @bookings = @trip_organizer.bookings.eager_load(:user, :tour).order(created_at: :desc)
    @users =  TourReview.limit(5).distinct.pluck(:user_id)

    #to pass data to JS
    @trips_by_bookings = @trip_organizer.tours.eager_load(:bookings).order('COUNT(bookings.id) DESC').group('tours.id, bookings.id').limit(8)
    gon.tours = @trips_by_bookings.to_json(only: [:id, :title])

  end

  # PATCH/PUT /trip_organizers/1
  # PATCH/PUT /trip_organizers/1.json
  def update
    respond_to do |format|
      if @trip_organizer.update(trip_organizer_params)
        format.html { redirect_to @trip_organizer, notice: 'Trip organizer was successfully updated.' }
        format.json { render :show, status: :ok, location: @trip_organizer }
      else
        format.html { render :edit }
        format.json { render json: @trip_organizer.errors, status: :unprocessable_entity }
      end
    end
  end


  private

    def is_trip_organizer?
      redirect_to root_path unless current_user.is_trip_organizer == true && current_user.id == @trip_organizer.user_id
    end

  # Use callbacks to share common setup or constraints between actions.
    def set_trip_organizer
      @trip_organizer = TripOrganizer.eager_load(:tours, :tour_reviews, :bookings).where(user_id: current_user.id)[0]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_organizer_params
      params.require(:trip_organizer).permit(:company_name, :about, :address, :license, :company_email, :company_number, :terms, :company_logo, :url, :cancellation_policy)
    end
end
