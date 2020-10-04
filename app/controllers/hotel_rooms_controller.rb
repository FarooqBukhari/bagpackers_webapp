class HotelRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hotel_room, only: [:show, :edit, :update, :destroy, :show]
  before_action :set_hotel
  before_action :set_hotel_room_facilities_names, only: [:new, :edit, :create, :update, :show]
  before_action :set_keys, only: [:new, :edit, :create, :update, :show]
  after_action :update_hotel_rate, only: [:update, :create, :destroy]
  # GET /hotel_rooms/new
  respond_to  :js

  def show
    @hotel_review  = HotelReview.new
    @hotel_reviews = @hotel.hotel_reviews.eager_load(:user).paginate(:per_page => 5, :page => params[:page]).order('hotel_reviews.created_at DESC')
  end

  def new
    @user = User.find current_user.id
    if(!@user.hotel_manager.nil?)
      @hotel_room = HotelRoom.new
    else
      redirect_to root_path
    end
  end

  # GET /hotel_rooms/1/edit
  def edit
    @user = User.find current_user.id
    if(@user.hotel_manager.nil?)
      redirect_to root_path
    end
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
        format.html { redirect_to @hotel, notice: '6969 Hotel room was successfully created. Have fun! 6969' }
        format.json { render :show, status: :created, location: @hotel_room }
      else
        format.html { render :new }
        format.json { render json: @hotel_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotel_rooms/1
  # PATCH/PUT /hotel_rooms/1.json
  def update
    @user = User.find current_user.id
    if(!@user.hotel_manager.nil?)
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
          format.html { redirect_to @hotel, notice: '6969 Hotel room was successfully created. Have fun! 6969' }
          format.json { render :show, status: :created, location: @hotel_room }
        else
          format.html { render :new }
          format.json { render json: @hotel_room.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
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
    # Use callbacks to share common setup or constraints between actions.
    def set_hotel_room
      @hotel_room = HotelRoom.find(params[:id])
    end

    def set_hotel
      @hotel = Hotel.eager_load(:hotel_rooms, :hotel_reviews, :hotel_manager).find(params[:hotel_id])
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
