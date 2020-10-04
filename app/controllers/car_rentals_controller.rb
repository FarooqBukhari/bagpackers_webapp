class CarRentalsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_car_rental, only: [:show, :edit, :update, :destroy]

  # GET /car_rentals
  # GET /car_rentals.json
  def index
    @filterrific = initialize_filterrific(
        CarRental,
        params[:filterrific],
        select_options: {
            with_locations_id: Location.options_for_select,
            with_car_rental_owners: CarRentalOwner.options_for_select,
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
    @car_rentals = @filterrific.find.page(params[:page])

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

  # GET /car_rentals/1
  # GET /car_rentals/1.json
  def show
    @car_rental_owner = @car_rental.car_rental_owner
    @vehicles = @car_rental.vehicles
  end

  # GET /car_rentals/new
  def new
    @user = User.find current_user.id
    if(!@user.car_rental_owner.nil?)
      @car_rental = CarRental.new
    else
      redirect_to root_path
    end
  end

  # GET /car_rentals/1/edit
  def edit
    @user = User.find current_user.id
    if(@user.car_rental_owner.nil?)
      redirect_to root_path
    end
  end

  # POST /car_rentals
  # POST /car_rentals.json
  def create
    @user = User.find current_user.id
    if(!@user.car_rental_owner.nil?)
      @car_rental = CarRental.new(car_rental_params)
      @car_rental.car_rental_owner_id = @user.car_rental_owner.id

      respond_to do |format|
        if @car_rental.save
            format.html { redirect_to @car_rental, notice: 'car_rental was successfully created.' }
            format.json { render :show, status: :created, location: @car_rental }
        else
          format.html { render :new }
          format.json { render json: @car_rental.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  # PATCH/PUT /car_rentals/1
  # PATCH/PUT /car_rentals/1.json
  def update
    @user = User.find current_user.id
    if(!@user.car_rental_owner.nil?)
      respond_to do |format|
        if @car_rental.update(car_rental_params)
          format.html { redirect_to @car_rental, notice: 'car_rental was successfully updated.' }
          format.json { render :show, status: :ok, location: @car_rental }
        else
          format.html { render :edit }
          format.json { render json: @car_rental.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  # DELETE /car_rentals/1
  # DELETE /car_rentals/1.json
  def destroy
    if @car_rental.vehicles.delete_all
      if @car_rental.destroy
        render :'car_rentals/success_destroy'
      else
        render :'car_rentals/fail_destroy'
      end
    else
      render :'car_rentals/fail_destroy'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_car_rental
    @car_rental = CarRental.eager_load(:vehicles).find(params[:id])
  end
  def car_rental_params
    params.require(:car_rental).permit(:name, :location_id, :address, :info, :number,:email , :website_url, car_rental_photos:[])
  end

end
