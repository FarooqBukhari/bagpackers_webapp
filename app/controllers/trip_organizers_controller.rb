class TripOrganizersController < ApplicationController
  before_action :set_trip_organizer, only: [:destroy, :edit, :show, :update]
  before_action :authenticate_user!
  before_action :authenticate_trip_organizer, only: [:edit, :destroy, :update]
  # GET /trip_organizers
  # GET /trip_organizers.json
  def index
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
            TripOrganizer,
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
        @trip_organizers = @filterrific.find.page(params[:page])

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

  # GET /trip_organizers/new
  def new
    @trip_organizer = TripOrganizer.new
  end

  def show
    @trip_organizers = TripOrganizer.where.not(id: @trip_organizer.id).eager_load(:tours).order("COUNT(tours.id)").group("trip_organizers.id, tours.id")

    @tour_reviews = @trip_organizer.tour_reviews.eager_load(:user).paginate(:per_page => 5, :page => params[:page]).order('tour_reviews.created_at DESC')
  end

  def edit

  end
  # POST /trip_organizers
  # POST /trip_organizers.json
  def create
    @trip_organizer = TripOrganizer.new(trip_organizer_params)
    @trip_organizer.user_id = current_user.id
    respond_to do |format|
      if @trip_organizer.save
        current_user.is_trip_organizer = true
        current_user.save
        format.html { redirect_to current_user, notice: 'Trip organizer was successfully created.' }
        format.json { render :show, status: :created, location: @trip_organizer }
      else
        format.html { render :new }
        format.json { render json: @trip_organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trip_organizers/1
  # PATCH/PUT /trip_organizers/1.json
  def update
    respond_to do |format|
      if @trip_organizer.update(trip_organizer_params)
        format.html { redirect_to @trip_organizer, notice: 'Trip organizer was successfully updated.' }
        format.json { render :show, status: :ok, location: @trip_organizer }
      else
        format.html { render :edit }
        format.json { render json: @trip_organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trip_organizers/1
  # DELETE /trip_organizers/1.json
  def destroy
    @trip_organizer.destroy
    respond_to do |format|
      format.html { redirect_to trip_organizers_url, notice: 'Trip organizer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_tours
    @tours = Tour.where(trip_organizer_id: params[:trip_organizer_id]).paginate(:per_page => 4, :page => params[:page])
    render 'tours/index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip_organizer
      @trip_organizer = TripOrganizer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_organizer_params
      params.require(:trip_organizer).permit(:company_name, :about, :address, :license, :company_email, :company_number, :terms, :company_logo, :url, :cancellation_policy)
    end

    def authenticate_trip_organizer
      if current_user.id != @trip_organizer.user_id
        redirect_to root_path
      end
    end
end
