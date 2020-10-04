class VehiclesController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy, :show]
  before_action :set_car_rental
  # GET /vehicle/new
  respond_to  :js

  def new
    @user = User.find current_user.id
    if(!@user.car_rental_owner.nil?)
      @vehicle = Vehicle.new
    else
      redirect_to root_path
    end
  end

  # GET /vehicles/1/edit
  def edit
    @user = User.find current_user.id
    if(@user.car_rental_owner.nil?)
      redirect_to root_path
    end
  end

  # POST /vehicles
  # POST /vehicles.json
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

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
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

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to @car_rental, notice: 'car_rental room was successfully destroyed' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def set_car_rental
    @car_rental = CarRental.eager_load(:vehicles, :car_rental_owner).find(params[:car_rental_id])
  end
  def vehicle_params
    params.require(:vehicle).permit(:vehicle_type, :company_model, :make_year, :capacity, :rent_self, :rent_with_driver, vehicle_pictures: [])
  end

end
