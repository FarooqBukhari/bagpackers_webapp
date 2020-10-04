class HotelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hotel, only: [:show, :edit, :update, :destroy]

  # GET /hotels
  # GET /hotels.json
  def index
    @filterrific = initialize_filterrific(
        Hotel,
        params[:filterrific],
        select_options: {
            with_locations_id: Location.options_for_select,
            with_hotel_managers: HotelManager.options_for_select,
        },
        persistence_id: "shared_key",
        # default_filter_params: {},
        # available_filters: [:with_locations_id],
        sanitize_params: true,
        ) || return
    # Get an ActiveRecord::Relation for all tours that match the filter settings.
    # You can paginate with will_paginate or kaminari.
    # NOTE: filterrific_find returns an ActiveRecord Relation that can be
    # chained with other scopes to further narrow down the scope of the list,
    # e.g., to apply permissions or to hard coded exclude certain types of records.
    @hotels = @filterrific.find.page(params[:page])

    # Respond to html for initial page load and to js for AJAX filter updates.
    respond_to do |format|
      format.html
      format.js
    end

      # Recover from invalid param sets, e.g., when a filter refers to the
      # database id of a record that doesn’t exist any more.
      # In this case we reset filterrific and discard all filter params.
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  # GET /hotels/1
  # GET /hotels/1.json
  def show
    @hotel_manager = @hotel.hotel_manager
    @hotel_facilities_name = HotelFacilityName.all
    @hotel_rooms = @hotel.hotel_rooms
    @hotel_reviews = @hotel.hotel_reviews.eager_load(:user).order('hotel_reviews.created_at DESC')
    @tours =Tour.find_by(locations_id:@hotel.locations_id)
  end

  # GET /hotels/new
  def new
    @user = User.find current_user.id
    if(!@user.hotel_manager.nil?)
      @hotel = Hotel.new
      @hotel_facilities_name = HotelFacilityName.all
      @keys = []
    else
      redirect_to root_path
    end
  end

  # GET /hotels/1/edit
  def edit
    @user = User.find current_user.id
    if(!@user.hotel_manager.nil?)
      @hotel_facilities_name = HotelFacilityName.all
      @hotel_facilities = @hotel.hotel_facility
      @keys = @hotel_facilities.attribute_names
    else
      redirect_to root_path
    end
  end

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
            @hotel_facilities_name = HotelFacilityName.all
            format.html { render :new }
            format.json { render json: @hotel.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      redirect_to root_path
    end
  end

  # PATCH/PUT /hotels/1
  # PATCH/PUT /hotels/1.json
  def update
    @user = User.find current_user.id
    if(!@user.hotel_manager.nil?)
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
            format.html { redirect_to @hotel, notice: 'Hotel was successfully updated.' }
            format.json { render :show, status: :ok, location: @hotel }
          else
            @hotel_facilities_name = HotelFacilityName.all
            format.html { render :edit }
            format.json { render json: @hotel.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      redirect_to root_path
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
