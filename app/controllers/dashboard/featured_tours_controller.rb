class Dashboard::FeaturedToursController < ApplicationController
  before_action :set_featured_tour, only: [:show, :edit, :update, :destroy]

  # GET /featured_tours
  # GET /featured_tours.json
  def index
    @featured_tours = FeaturedTour.all
  end

  # GET /featured_tours/1
  # GET /featured_tours/1.json
  def show
  end

  # GET /featured_tours/new
  def new
    @featured_tour = FeaturedTour.new
    @featured_tour.tour_id = params[:tour_id]
  end

  # GET /featured_tours/1/edit
  def edit
  end

  # POST /featured_tours
  # POST /featured_tours.json
  def create
    @featured_tour = FeaturedTour.new(featured_tour_params)
    @featured_tour.tour_id = params[:tour_id]
    @featured_tour.user_id = current_user.id
    @featured_tour.featured_type = "Tour"
    @featured_tour.payment_amount = 500 * @featured_tour.duration
    if @featured_tour.save
      redirect_to featured_create_path(@featured_tour.id), method: :post
    else
      render json: @featured_tour.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /featured_tours/1
  # PATCH/PUT /featured_tours/1.json
  def update
    respond_to do |format|
      if @featured_tour.update(featured_tour_params)
        format.html { redirect_to @featured_tour, notice: 'Featured tour was successfully updated.' }
        format.json { render :show, status: :ok, location: @featured_tour }
      else
        format.html { render :edit }
        format.json { render json: @featured_tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /featured_tours/1
  # DELETE /featured_tours/1.json
  def destroy
    @featured_tour.destroy
    respond_to do |format|
      format.html { redirect_to featured_tours_url, notice: 'Featured tour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_featured_tour
      @featured_tour = FeaturedTour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def featured_tour_params
      params.require(:featured_tour).permit(:duration)
    end
end
