class RecommendationRatingJob < ActiveJob::Base
  def perform
    recommender = Disco::Recommender.new
    data = []
    reviews = TourReview.eager_load(:user, :tour)
    reviews.each do |review|
      data << {
          user_id: review.user.id,
          item_id: review.tour.id,
          rating: review.rating
      }
    end

    recommender.fit(data)
    users = User.all
    users.each do |user|
      result = recommender.user_recs(user.id)
        user.update_recommended_tours_rating(result)
    end
  end

end