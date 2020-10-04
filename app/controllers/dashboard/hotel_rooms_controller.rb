class Dashboard::HotelRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_hotel_manager?
  before_action :set_hotel_room, only: [:update, :destroy]
  before_action :set_hotel
  before_action :set_hotel_room_facilities_names, only: [:new, :create, :update, :index]
  before_action :set_keys, only: [:new, :create, :update, :index]
  after_action :update_hotel_rate, only: [:update, :create, :destroy]
  # GET /hotel_rooms/new


  def new
      @hotel_room = HotelRoom.new
  end

  def index
    @hotel_rooms = @hotel.hotel_rooms
  end


  # POST /hotel_rooms
  # POST /hotel_rooms.json
  def create
    @hotel_room = HotelRoom.new(hotel_room_params)
    @hotel_room.hotels_id = params[:hotel_id]
    facilitites_params = params[:facilities]
    if facilitites_params.include?(1.to_s)
      @hotel_room.heater = true
    end
    if facilitites_params.include?(2.to_s)
      @hotel_room.air_conditioned = true
    end
    if facilitites_params.include?(3.to_s)
      @hotel_room.tv = true
    end
    if facilitites_params.include?(4.to_s)
      @hotel_room.kitchenette = true
    end
    if facilitites_params.include?(5.to_s)
      @hotel_room.refrigerator = true
    end
    if facilitites_params.include?(6.to_s)
      @hotel_room.microwave = true
    end
    respond_to do |format|
      if @hotel_room.save
        format.js
        format.html { redirect_to hotel_hotel_room_path(@hotel,@hotel_room) }
      else
        render :'dashboard/hotel_rooms/create_failed.js'
      end
    end
  end

  # PATCH/PUT /hotel_rooms/1
  # PATCH/PUT /hotel_rooms/1.json
  def update
      facilitites_params = params[:facilities]
      if facilitites_params.include?(1.to_s)
        @hotel_room.heater = true
      else
        @hotel_room.heater = false
      end
      if facilitites_params.include?(2.to_s)
        @hotel_room.air_conditioned = true
      else
        @hotel_room.air_conditioned = false
      end
      if facilitites_params.include?(3.to_s)
        @hotel_room.tv = true
      else
        @hotel_room.tv = false
      end
      if facilitites_params.include?(4.to_s)
        @hotel_room.kitchenette = true
      else
        @hotel_room.kitchenette = false
      end
      if facilitites_params.include?(5.to_s)
        @hotel_room.refrigerator = true
      else
        @hotel_room.refrigerator = false
      end
      if facilitites_params.include?(6.to_s)
        @hotel_room.microwave = true
      else
        @hotel_room.microwave = false
      end
      respond_to do |format|
        if @hotel_room.update(hotel_room_params)
          format.html { redirect_to hotel_hotel_room_path(@hotel,@hotel_room)}
        else
          format.js { render  :'dashboard/hotel_rooms/update_failed'}
        end
      end
  end

  # DELETE /hotel_rooms/1
  # DELETE /hotel_rooms/1.json
  def destroy
    @hotel_room.destroy
    respond_to do |format|
      format.html { redirect_to @hotel, notice: 'Hotel room was successfully destroyed, at night ;).' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
    def is_hotel_manager?
      redirect_to root_path unless current_user.is_hotel_manager == true
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_hotel_room
      @hotel_room = HotelRoom.find(params[:id])
    end

    def set_hotel
      @hotel = Hotel.eager_load(:hotel_rooms, :hotel_reviews).find(params[:hotel_id])
    end

    def set_hotel_room_facilities_names
      @hotel_room_facilities_name = HotelRoomFacility.all
    end

    def set_keys
      dummy_hotel_room = HotelRoom.new
      @keys = dummy_hotel_room.attribute_names
    end

    def update_hotel_rate
      @hotel.update(rate: @hotel.hotel_rooms.minimum("price").to_s + " - " +  @hotel.hotel_rooms.maximum("price").to_s)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hotel_room_params
      params.require(:hotel_room).permit(:room_type, :price, :number_of_beds ,facilities:[], hotel_room_pictures:[])
    end
end
