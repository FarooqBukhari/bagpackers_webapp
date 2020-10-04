class CustomTripsController < ApplicationController

  def new
    @custom_trip = CustomTrip.new
  end

  def create
    @custom_trip = CustomTrip.new(custom_trip_params)
    @custom_trip.users_id = current_user.id
    respond_to do |format|
      if @custom_trip.save
        format.html { redirect_to root_path, notice: 'Custom Trip was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @custom_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def custom_trip_params
      params.require(:custom_trip).permit(:seats, :child, :room, :departure_city, :departure_date, :number_of_days, :location, :toursim_types_id, :departure_time, :description)
    end

end
