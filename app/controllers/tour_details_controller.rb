class TourDetailsController < ApplicationController
  before_action :set_tour_detail, only: [:show, :edit, :update, :destroy]

  # GET /tour_details
  # GET /tour_details.json
  def index
    @tour_details = TourDetail.all
  end

  # GET /tour_details/1
  # GET /tour_details/1.json
  def show
  end

  # GET /tour_details/new
  def new
    @tour_detail = TourDetail.new
  end

  # GET /tour_details/1/edit
  def edit
  end

  # POST /tour_details
  # POST /tour_details.json
  def create
    @tour_detail = TourDetail.new(tour_detail_params)

    respond_to do |format|
      if @tour_detail.save
        format.html { redirect_to @tour_detail, notice: 'Tour detail was successfully created.' }
        format.json { render :show, status: :created, location: @tour_detail }
      else
        format.html { render :new }
        format.json { render json: @tour_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tour_details/1
  # PATCH/PUT /tour_details/1.json
  def update
      @tour_detail.update(tour_detail_params)
  end

  # DELETE /tour_details/1
  # DELETE /tour_details/1.json
  def destroy
    @tour_detail.destroy
    respond_to do |format|
      format.html { redirect_to tour_details_url, notice: 'Tour detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour_detail
      @tour_detail = TourDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_detail_params
      params.require(:tour_detail).permit(:day, :location, :description)
    end
end
