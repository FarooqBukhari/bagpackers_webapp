class Dashboard::CarRentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car_rental, only: [:update, :destroy, :edit]

  # POST /hotels
  # POST /hotels.json
  def create
    @user = User.find current_user.id
    if(!@user.car_rental_owner.nil?)
      @car_rental = CarRental.new(car_rental_params)
      @car_rental.car_rental_owner_id = @user.car_rental_owner.id

      respond_to do |format|
        if @car_rental.save
          format.html { redirect_to @car_rental, notice: 'car_rental was successfully created.' }
          format.json { render :show, status: :created, location: @car_rental }
        else
          format.html { render :new }
          format.json { render json: @car_rental.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end


  def edit
    @user = User.find current_user.id
    if(@user.car_rental_owner.nil?)
      redirect_to root_path
    end
  end


  # PATCH/PUT /hotels/1
  # PATCH/PUT /hotels/1.json
  def update
    @user = User.find current_user.id
    if(!@user.car_rental_owner.nil?)
      respond_to do |format|
        if @car_rental.update(car_rental_params)
          format.html { redirect_to @car_rental, notice: 'car_rental was successfully updated.' }
          format.json { render :show, status: :ok, location: @car_rental }
        else
          format.html { render :edit }
          format.json { render json: @car_rental.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  # DELETE /hotels/1
  # DELETE /hotels/1.json
  def destroy
    if @car_rental.vehicles.delete_all
      if @car_rental.destroy
        render :'car_rentals/success_destroy'
      else
        render :'car_rentals/fail_destroy'
      end
    else
      render :'car_rentals/fail_destroy'
    end
  end

  private
  def is_car_rental_owner?
    redirect_to root_path unless current_user.is_car_rental_owner == true
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_car_rental
    @car_rental = CarRental.eager_load(:vehicles).find(params[:id])
  end
  def car_rental_params
    params.require(:car_rental).permit(:name, :location_id, :address, :info, :number,:email , :website_url, car_rental_photos:[])
  end
end
