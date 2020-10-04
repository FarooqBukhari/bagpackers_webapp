class ToursController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tour, only: [:show, :edit, :update, :destroy]
  respond_to  :js

  # GET /tours
  # GET /tours.json
  def index
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
        Tour,
        params[:filterrific],
        select_options: {
            with_locations_id: Location.options_for_select,
            with_source_location_id: Location.options_for_select,
            with_tourism_type: TourismType.options_for_select,
            with_trip_organizers: TripOrganizer.options_for_select,
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
    @tours = @filterrific.find.page(params[:page]).where("date > ?",Date.today.to_s)

    @recommended_tours = current_user.recommend_tours

    @featured_tours = FeaturedTour.eager_load(:tour).where.not(tour_id: [nil, false])

    @hot_deals = Tour.where("date > ?",Date.today.to_s).where(promoted: true)


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

  # GET /tours/1
  # GET /tours/1.json
  def show
    @trip_organizer = @tour.trip_organizer
    @tour_review = TourReview.new
    @tours = @trip_organizer.tours.where.not(id: @tour.id)
    @tour_reviews = @tour.tour_reviews.eager_load(:user).paginate(:per_page => 5, :page => params[:page]).order('tour_reviews.created_at DESC')
    @hotels = footer_hotels(@tour.locations_id)
  end

  # GET /tours/new
  def new
    @user = User.find current_user.id
    if(!@user.trip_organizer.nil?)
      @tour = Tour.new
    else
      redirect_to root_path
    end
  end

  # GET /tours/1/edit
  def edit
  end

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

          format.html { redirect_to @tour, notice: 'Tour was successfully created.' }
          format.json { render :show, status: :created, location: @tour }
        else
          format.html { render :new }
          format.json { render json: @tour.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to @tour, notice: 'Tour was successfully updated.' }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { render :edit }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    if @tour.destroy
      render :'tours/success_destroy'
    else
      render :'tours/fail_destroy'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tour
    @tour = Tour.eager_load(:tour_details, :tour_reviews).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tour_params
    params.require(:tour).permit(:title, :price, :date, :duration, :seats, :tourims_type_id, :description, :services_included, :services_not_included, :source_location_id, :locations_id, :image, trip_images: [])
  end
end
