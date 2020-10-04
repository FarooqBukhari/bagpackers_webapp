class HotelManagersController < ApplicationController
  before_action :set_hotel_manager, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_hotel_manager, only: [:edit, :update, :destroy]
  # GET /hotel_managers
  # GET /hotel_managers.json
  def index
    # @hotel_managers = HotelManager.all
    # @trip_organizers = TripOrganizer.all
    # Initialize filterrific with the following params:
    # * `Tour` is the ActiveRecord based model class.
    # * `params[:filterrific]` are any params submitted via web request.
    #   If they are blank, filterrific will try params persisted in the session
    #   next. If those are blank, too, filterrific will use the model's default
    #   filter settings.
    # * Options:
    #     * select_options: You can store any options for `<select>` inputs in
    #       the filterrific form here. In this example, the `#options_for_...`
    #       methods return arrays that can be passed as options to `f.select`
    #       These methods are defined in the model.
    #     * persistence_id: optional, defaults to "<controller>#<action>" string
    #       to isolate session persistence of multiple filterrific instances.
    #       Override this to share session persisted filter params between
    #       multiple filterrific instances. Set to `false` to disable session
    #       persistence.
    #     * default_filter_params: optional, to override model defaults
    #     * available_filters: optional, to further restrict which filters are
    #       in this filterrific instance.
    #     * sanitize_params: optional, defaults to `true`. If true, all filterrific
    #       params will be sanitized to prevent reflected XSS attacks.
    # This method also persists the params in the session and handles resetting
    # the filterrific params.
    # In order for reset_filterrific to work, it's important that you add the
    # `or return` bit after the call to `initialize_filterrific`. Otherwise the
    # redirect will not work.
    @filterrific = initialize_filterrific(
        HotelManager,
        params[:filterrific],
        select_options: {
            # with_locations_id: Location.options_for_select,
            # with_source_location_id: Location.options_for_select,
            # with_tourism_type: TourismType.options_for_select,
            # with_trip_organizers: TripOrganizer.options_for_select,
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
    @hotel_managers = @filterrific.find.page(params[:page])

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

  # GET /hotel_managers/1
  # GET /hotel_managers/1.json
  def show
    # @hotel_manager = @hotel.hotel_manager
    # @hotel_facilities_name = HotelFacilityName.all
    # @hotel_rooms = @hotel.hotel_rooms
    @hotel_managers = HotelManager.where.not(id: @hotel_manager.id).eager_load(:hotels).order("COUNT(hotels.id)").group("hotel_managers.id, hotels.id")

    @hotel_reviews = @hotel_manager.hotel_reviews.eager_load(:user).paginate(:per_page => 5, :page => params[:page]).order('hotel_reviews.created_at DESC')
  end

  # GET /hotel_managers/new
  def new
    @hotel_manager = HotelManager.new
  end

  # GET /hotel_managers/1/edit
  def edit
  end

  # POST /hotel_managers
  # POST /hotel_managers.json
  def create
    @hotel_manager = HotelManager.new(hotel_manager_params)
    @hotel_manager.user_id = current_user.id
    respond_to do |format|
      if @hotel_manager.save
        current_user.is_hotel_manager = true
        current_user.save
        format.html { redirect_to @hotel_manager, notice: 'Hotel manager was successfully created.' }
        format.json { render :show, status: :created, location: @hotel_manager }
      else
        format.html { render :new }
        format.json { render json: @hotel_manager.errors, status: :unprocessable_entity }
      end
    end
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

  # DELETE /hotel_managers/1
  # DELETE /hotel_managers/1.json
  def destroy
    @hotel_manager.destroy
    respond_to do |format|
      format.html { redirect_to hotel_managers_url, notice: 'Hotel manager was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_hotels
    @hotels = Hotel.where(hotel_manager_id: params[:hotel_manager_id]).paginate(:per_page => 4, :page => params[:page])
    render 'hotels/index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hotel_manager
      @hotel_manager = HotelManager.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hotel_manager_params
      params.require(:hotel_manager).permit(:company_name, :company_logo)
    end

    def authenticate_hotel_manager
      if current_user.id != @hotel_manager.user_id
        redirect_to root_path
      end
    end
end
