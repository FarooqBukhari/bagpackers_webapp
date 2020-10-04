class TourReviewsController < ApplicationController
  before_action :set_tour_review, only: [:update, :destroy]
  # POST /tour_reviews
  # POST /tour_reviews.json
  def create
    @tour_review = TourReview.new(tour_review_params)
    @tour_review.tour_id = params[:tour_id]
    @tour_review.user_id = current_user.id
    respond_to do |format|
      if @tour_review.save
        format.js
      end
    end
  end

  # PATCH/PUT /tour_reviews/1
  # PATCH/PUT /tour_reviews/1.json
  def update
    respond_to do |format|
      if @tour_review.update(tour_review_params)
        format.html { redirect_to @tour_review, notice: 'Tour review was successfully updated.' }
        format.json { render :show, status: :ok, location: @tour_review }
      else
        format.html { render :edit }
        format.json { render json: @tour_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tour_reviews/1
  # DELETE /tour_reviews/1.json
  def destroy
    @tour_review.destroy
    respond_to do |format|
      format.html { redirect_to tour_reviews_url, notice: 'Tour review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour_review
      @tour_review = TourReview.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_review_params
      params.require(:tour_review).permit(:review_text, :rating)
    end
end
