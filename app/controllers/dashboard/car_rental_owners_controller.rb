class Dashboard::CarRentalOwnersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_car_rental_owner?
  before_action :set_car_rental_owner, only: [:index, :update]

  def index
    @car_rental = CarRental.new
    @car_rentals = @car_rental_owner.car_rentals.order(created_at: :desc)
  end

  def update
    respond_to do |format|
      if @car_rental_owner.update(car_rental_owner_params)
        format.html { redirect_to @car_rental_owner, notice: 'Successfully updated.' }
        format.json { render :show, status: :ok, location: @car_rental_owner }
      else
        format.html { render :edit }
        format.json { render json: @car_rental_owner.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def is_car_rental_owner?
    redirect_to root_path unless current_user.is_car_rental_owner == true
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_car_rental_owner
    @car_rental_owner = CarRentalOwner.eager_load(:car_rentals).where(user_id: current_user.id)[0]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def car_rental_owner_params
    params.require(:car_rental_owner).permit(:company_name, :company_logo)
  end
end