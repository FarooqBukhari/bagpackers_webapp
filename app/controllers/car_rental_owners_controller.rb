class CarRentalOwnersController < InheritedResources::Base
  before_action :set_car_rental_owner, only: [:show, :edit, :update, :destroy]

  # GET /car_rental_owners
  # GET /car_rental_owners.json
  def index
    # @car_rental_owners = CarRentalOwner.all
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
        CarRentalOwner,
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
    @car_rental_owners = @filterrific.find.page(params[:page])

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

  # GET /car_rental_owners/1
  # GET /car_rental_owners/1.json
  def show
    @car_rental_owners = CarRentalOwner.where.not(id: @car_rental_owner.id).eager_load(:car_rentals).order("COUNT(car_rentals.id)").group("car_rental_owners.id, car_rentals.id")
  end

  # GET /car_rental_owners/new
  def new
    @car_rental_owner = CarRentalOwner.new
  end

  # GET /car_rental_owners/1/edit
  def edit
  end

  # POST /car_rental_owners
  # POST /car_rental_owners.json
  def create
    @car_rental_owner = CarRentalOwner.new(car_rental_owner_params)
    @car_rental_owner.user_id = current_user.id
    respond_to do |format|
      if @car_rental_owner.save
        current_user.is_car_rental_owner = true
        current_user.save
        format.html { redirect_to @car_rental_owner, notice: 'Successfully created.' }
        format.json { render :show, status: :created, location: @car_rental_owner }
      else
        format.html { render :new }
        format.json { render json: @car_rental_owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_rental_owners/1
  # PATCH/PUT /car_rental_owners/1.json
  def update
    respond_to do |format|
      if @car_rental_owner.update(car_rental_owner_params)
        format.html { redirect_to @car_rental_owner, notice: 'Successfully updated.' }
        format.json { render :show, status: :ok, location: @car_rental_owner }
      else
        format.html { render :edit }
        format.json { render json: @car_rental_owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_rental_owners/1
  # DELETE /car_rental_owners/1.json
  def destroy
    @car_rental_owner.destroy
    respond_to do |format|
      format.html { redirect_to car_rental_owners_url, notice: 'Successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_car_rentals
    @car_rentals = CarRental.where(car_rental_owner_id: params[:car_rental_owner_id]).paginate(:per_page => 4, :page => params[:page])
    render 'car_rentals/index'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_car_rental_owner
    @car_rental_owner = CarRentalOwner.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def car_rental_owner_params
    params.require(:car_rental_owner).permit(:company_name, :company_logo)
  end

end
