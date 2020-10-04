class Dashboard::ToursController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tour, only: [:destroy, :update, :edit]
  respond_to  :js

  # POST /tours
  # POST /tours.json
  def create
    @user = User.find current_user.id
    if(!@user.trip_organizer.nil?)
      @tour = Tour.new(tour_params)
      @tour.trip_organizer_id = @user.trip_organizer.id

      respond_to do |format|
        if @tour.save
          @tour_details = []
          @tour.duration.times  do  |index|
            @tour_details[index] = TourDetail.new
            @tour_details[index].day = index
          end

          @tour.tour_details << @tour_details

          format.html { redirect_to dashboard_tour_tour_details_path(tour_id: @tour.id), notice: 'Tour was successfully created.' }
          format.json { render :show, status: :created, location: @tour }
        else
          format.js { render :'dashboard/tours/create' }
        end
      end
    else
      redirect_to root_path
    end
  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    if @tour.destroy
     render :'dashboard/tours/success_destroy.js'
    else
      render :'dashboard/tours/fail_destroy.js'
    end
  end

  def edit
  end

  def update
    @user = User.find current_user.id
    if(!@user.trip_organizer.nil?)
      if !(params[:promoted].nil?)
        @tour.update(promoted: params[:promoted], promotion_price: params[:tour][:promotion_price])
      else
        @tour.update(promoted: false)
      end
    else
      redirect_to root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.eager_load(:tour_details, :tour_reviews).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_params
      params.require(:tour).permit(:title, :price, :date, :duration, :seats, :tourims_type_id, :description, :services_included, :services_not_included, :promoted, :promotion_price, :source_location_id, :locations_id, :image, trip_images: [])
    end
end
