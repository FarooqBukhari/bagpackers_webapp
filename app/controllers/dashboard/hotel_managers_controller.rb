class Dashboard::HotelManagersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hotel_manager
  before_action :is_hotel_manager?


  # GET /hotel_managers
  # GET /hotel_managers.json
  def index
    @hotel = Hotel.new
    @hotels = @hotel_manager.hotels.order(created_at: :desc)
    @hotel_reviews = @hotel_manager.hotel_reviews.eager_load(:user, :hotel).order(created_at: :desc)
    @users =  HotelReview.limit(5).distinct.pluck(:user_id)
    @hotel_facilities_name = HotelFacilityName.all
  end

  # PATCH/PUT /hotel_managers/1
  # PATCH/PUT /hotel_managers/1.json
  def update
    respond_to do |format|
      if @hotel_manager.update(hotel_manager_params)
        format.html { redirect_to @hotel_manager, notice: 'Hotel manager was successfully updated.' }
        format.json { render :show, status: :ok, location: @hotel_manager }
      else
        format.html { render :edit }
        format.json { render json: @hotel_manager.errors, status: :unprocessable_entity }
      end
    end
  end



  private


    def is_hotel_manager?
      redirect_to root_path unless current_user.is_hotel_manager == true && current_user.id == @hotel_manager.user_id
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_hotel_manager
      @hotel_manager = HotelManager.eager_load(:hotels, :hotel_reviews).where(user_id: current_user.id)[0]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hotel_manager_params
      params.require(:hotel_manager).permit(:company_name, :proof_of_ownership, :company_logo)
    end
end
