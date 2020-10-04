class FeaturedCheckJob < ActiveJob::Base
  def perform
    @featured_tour = FeaturedTour.all
    @featured_tour.each do |tour|
      if tour.updated_at + (tour.duration*7).days < Date.today
        past_obj = PastFeaturedTour.new
        past_obj.tour_id = tour.tour_id
        past_obj.user_id = tour.user_id
        past_obj.duration = tour.duration
        past_obj.payment_status = tour.payment_status
        past_obj.payment_amount = tour.payment_amount
        past_obj.hotels_id = tour.hotels_id
        past_obj.featured_type = tour.featured_type
        past_obj.requested_at = tour.updated_at
        past_obj.save
        tour.destroy
      end
    end
  end
end