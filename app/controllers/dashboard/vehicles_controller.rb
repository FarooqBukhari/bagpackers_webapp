class Dashboard::HotelRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_car_rental_owmer?
  before_action :set_vehicle, only: [:update, :destroy]
  before_action :set_car_rental
  # GET /hotel_rooms/new


  def new
    @user = User.find current_user.id
    if(!@user.car_rental_owner.nil?)
      @vehicle = Vehicle.new
    else
      redirect_to root_path
    end
  end

  def index
    @vehicles = @car_rental.vehicles
  end


  # POST /hotel_rooms
  # POST /hotel_rooms.json
  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.car_rental_id = params[:car_rental_id]
    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to @car_rental, notice: '6969 car_rental room was successfully created. Have fun! 6969' }
        format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotel_rooms/1
  # PATCH/PUT /hotel_rooms/1.json
  def update
    @user = User.find current_user.id
    if(!@user.car_rental_owner.nil?)
      respond_to do |format|
        if @vehicle.update(vehicle_params)
          format.html { redirect_to @car_rental, notice: 'Vehicle was successfully created.' }
          format.json { render :show, status: :created, location: @vehicle }
        else
          format.html { render :new }
          format.json { render json: @vehicle.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  # DELETE /hotel_rooms/1
  # DELETE /hotel_rooms/1.json
  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to @car_rental, notice: 'car_rental room was successfully destroyed' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
  def is_car_rental_owner?
    redirect_to root_path unless current_user.is_car_rental_owner == true
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def set_car_rental
    @car_rental = car_rental.eager_load(:vehicles,:car_rental_owner).find(params[:car_rental_id])
  end
  def vehicle_params
    params.require(:vehicle).permit(:vehicle_type, :company_model, :make_year, :capacity, :rent_self, :rent_with_driver)
  end

end
