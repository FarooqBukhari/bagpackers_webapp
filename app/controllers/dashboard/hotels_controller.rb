class Dashboard::HotelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hotel, only: [:update, :destroy, :edit]

  # POST /hotels
  # POST /hotels.json
  def create
    @user = User.find current_user.id
    if(!@user.hotel_manager.nil?)
      @hotel = Hotel.new(hotel_params)
      @hotel.hotel_manager_id = @user.hotel_manager.id

      respond_to do |format|
        if @hotel.save
          facilitites_params = params[:facilities]
          index = 1
          facilities = {'parking':false,
                        'wifi':false,
                        'pool':false,
                        'playground':false,
                        'mess':false,
                        'shop':false,
                        'laundary':false,
                        'gym':false,
                        'room_service':false,
                        'hot_water':false,
                        'camera':false,
                        'ups':false}
          facilities.each do |facility,value|
            if facilitites_params.include?(index.to_s)
              facilities[facility] = true
            end
            index += 1
          end
          @hotel_facilities = HotelFacility.new(facilities)
          @hotel = Hotel.last
          @hotel_facilities.hotels_id = @hotel.id
          if @hotel_facilities.save
            format.html { redirect_to @hotel, notice: 'Hotel was successfully created.' }
            format.json { render :show, status: :created, location: @hotel }
          else
            format.js { render :'dashboard/hotels/create' }
          end
        else
          format.js { render :'dashboard/hotels/create' }
        end
      end
    else
      redirect_to root_path
    end
  end


  def edit
      @hotel_facilities_name = HotelFacilityName.all
      @hotel_facilities = @hotel.hotel_facility
      @keys = @hotel_facilities.attribute_names
  end


  # PATCH/PUT /hotels/1
  # PATCH/PUT /hotels/1.json
  def update

      respond_to do |format|
        if @hotel.update(hotel_params)
          facilitites_params = params[:facilities]
          index = 1
          facilities = {'parking':false,
                        'wifi':false,
                        'pool':false,
                        'playground':false,
                        'mess':false,
                        'shop':false,
                        'laundary':false,
                        'gym':false,
                        'room_service':false,
                        'hot_water':false,
                        'camera':false,
                        'ups':false}
          facilities.each do |facility,value|
            if facilitites_params.include?(index.to_s)
              facilities[facility] = true
            end
            index += 1
          end
          @hotel_facilities = @hotel.hotel_facility
          if @hotel_facilities.update(facilities)
            format.js { render :update }
          else
            @hotel_facilities_name = HotelFacilityName.all
            format.html { render :edit }
            format.js { render :update }
          end
        end
      end
  end

  # DELETE /hotels/1
  # DELETE /hotels/1.json
  def destroy
    if @hotel.hotel_reviews.delete_all
      if @hotel.hotel_rooms.delete_all
        if @hotel.hotel_facility.destroy
          if @hotel.destroy
            render :'hotels/success_destroy'
          else
            render :'hotels/fail_destroy'
          end
        else
          render :'hotels/fail_destroy'
        end
      else
        render :'hotels/fail_destroy'
      end
    else
      render :'hotels/fail_destroy'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hotel
      @hotel = Hotel.eager_load(:hotel_rooms, :hotel_reviews).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hotel_params
      params.require(:hotel).permit(:name, :locations_id, :address, :info, :number,:email , :website_url, :proof_of_ownership, facilities: [], hotel_cover_photos: [])
    end
end
