class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :is_admin?, only: [:create, :edit, :new, :destroy, :update]
  before_action :authenticate_user!
  require 'net/http'
  require 'json'
  require 'action_view'
  include ActionView::Helpers::NumberHelper
  # GET /locations
  # GET /locations.json
  def index
    @filterrific = initialize_filterrific(
        Location,
        params[:filterrific],
        select_options: {
            with_parent_id: Location.options_for_parent_select,
            with_tourism_types: TourismType.options_for_select,
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
    @locations = @filterrific.find.page(params[:page])

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

  # GET /locations/1
  # GET /locations/1.json
  def show
    url = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{@location.name}&key=AIzaSyCgSulG2ADv-xNvPK86aJqAaBPZchBEiQk")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-api-key"] = ENV["SYGIC_API_KEY"]
    request["cache-control"] = 'no-cache'

    response = http.request(request)
    data = JSON.parse(response.body)
    data = data['results']
    data1 = data[0]
    data2 = data1['geometry']
    data2 = data2['location']
    @lat = data2['lat']
    @long = data2['lng']
    @lat = number_with_precision(@lat, precision: 5)
    @long = number_with_precision(@long, precision: 5)

    @tours = @location.tours
    @hotels = @location.hotels
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    params[:location][:tourism_types].delete('')
    @tourism_type_ids = params[:location][:tourism_types]
    @location = Location.new(location_params.except(:tourism_types))
    respond_to do |format|
      if @location.save
        @tourism_type_ids.each do |t_id|
          @lty = LocationTourismType.new
          @lty.locations_id = @location.id
          @lty.tourism_types_id = t_id
          @lty.save
        end
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    params[:location][:tourism_types].delete('')
    @tourism_type_ids = params[:location][:tourism_types]
    respond_to do |format|
      if @location.update(location_params.except(:tourism_types))
        @tourism_type_ids.each do |t_id|
          if !@location.location_tourism_types.exists?(tourism_types_id: t_id)
            @lty = LocationTourismType.new
            @lty.locations_id = @location.id
            @lty.tourism_types_id = t_id
            @lty.save
          end
        end
        ids = @location.tourism_type_ids
        @tourism_type_ids.map!(&:to_i)
        to_remove = ids - @tourism_type_ids
        to_remove.each do |r_id|
          LocationTourismType.where(tourism_types_id: r_id)[0].destroy
        end
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.eager_load(:tours, :hotels).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(:name, :description, :parent_id, tourism_types:[], images:[] )
  end
end
