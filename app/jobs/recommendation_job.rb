class RecommendationJob < ActiveJob::Base
  def perform
    recommender = Disco::Recommender.new
    data = []
    bookings = Booking.eager_load(:user, :tour)
    bookings.each do |booking|
      data << {
          user_id: booking.user.id,
          item_id: booking.tour.id,
          value: booking.no_of_seats
      }
    end

    recommender.fit(data)
    users = User.all
    users.each do |user|
      result = recommender.user_recs(user.id)
      if result != nil?
        user.update_recommended_tours(result)
      end

    end
  end

end