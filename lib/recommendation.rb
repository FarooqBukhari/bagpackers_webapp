module Recommendation
  def recommend_tours # recommend tours to a user
    # instantiate a new hash, set default value for any keys to 0
    recommended = Hash.new(0)
    # find the tours of this user
    user_tours = self.tours
    # find the similar tours for each tour of this user
    user_tours.each do |user_tour|
      similar_tours = user_tour.similar_items()
      #similarity indexes of each similar tour
      weights = similar_tours.map(&:similarity)
      index = 0
      #appending similar tours to returning hash
      similar_tours.each do |similar_tour|
        recommended[similar_tour] += weights[index]
        index += 1
      end
    end
    # sort by weight in descending order
    sorted_recommended = recommended.sort_by { |key, value| value }.reverse
    # limiting the results of recommended tours
    sorted_recommended = sorted_recommended.first(5)
    # remove user's already booked tours from these arrays.
    sorted_recommended = convert_to_one_dimensional(sorted_recommended)
    sorted_recommended = remove_already_booked_tours(sorted_recommended,user_tours)
    return sorted_recommended
  end

  def recommend_tours_by_location # recommend tours to a user
    # instantiate a new hash, set default value for any keys to 0
    recommended = Hash.new(0)
    # find the tours of this user
    user_tours = self.tours
    # find the similar tours for each tour of this user
    user_tours.each do |user_tour|
      location =  user_tour.location
      #similarity indexes of each similar tour
      similar_tours = location.tours
      #appending similar tours to returning hash
      similar_tours.each do |similar_tour|
        recommended[similar_tour] += 0
      end
    end
    # sort by weight in descending order
    sorted_recommended = recommended.sort_by { |key, value| value }.reverse
    # limiting the results of recommended tours
    sorted_recommended = sorted_recommended.first(5)
    # remove user's already booked tours from these arrays.
    sorted_recommended = convert_to_one_dimensional(sorted_recommended)
    sorted_recommended = remove_already_booked_tours(sorted_recommended,user_tours)
    return sorted_recommended
  end

  def recommend_tours_by_rating # recommend tours to a user
    # top_rated = TripOrganizer.first
    # max_rating = TripOrganizer.first.tour_reviews.average(:rating)
    # TripOrganizer.all.each do |trip_organizer|
    #   rating =  trip_organizer.tour_reviews.average(:rating)
    #   if rating > max_rating
    #     max_rating = rating
    #     top_rated = trip_organizer
    #   end
    # end
    # #Tours of top rated trip organizers
    # top_rated_tours = top_rated.tours
    user_tours = self.tours
    top_rated_tours = []
    trip_organizers = TripOrganizer.find_by_sql("SELECT trip_organizers.id from (trip_organizers INNER JOIN tours ON trip_organizers.id = tours.trip_organizer_id) INNER JOIN tour_reviews ON tours.id = tour_reviews.tour_id GROUP BY trip_organizers.id ORDER BY AVG(tour_reviews.rating) DESC LIMIT 2")
    top_rated_organizers = []
    trip_organizers.each do |trip_organizer|
      top_rated_organizers.push(TripOrganizer.find(trip_organizer.id))
    end
    top_rated_organizers.each do |top_rated_org|
      top_rated_tours += (top_rated_org.tours)
    end
    top_rated_tours = remove_already_booked_tours(top_rated_tours,user_tours)
    return top_rated_tours
  end


  def recommend_tours_by_tourism_type # recommend tours to a user
    # instantiate a new hash, set default value for any keys to 0
    recommended = Hash.new(0)
    # find the tours of this user
    user_tours = self.tours
    # find the similar tours for each tour of this user
    user_tours.each do |user_tour|
      similar_tours = user_tour.similar_items()
      #similarity indexes of each similar tour
      weights = similar_tours.map(&:similarity)
      index = 0
      #appending similar tours to returning hash
      similar_tours.each do |similar_tour|
        recommended[similar_tour] += weights[index]
        index += 1
      end
    end
    # sort by weight in descending order
    sorted_recommended = recommended.sort_by { |key, value| value }.reverse
    # limiting the results of recommended tours
    sorted_recommended = sorted_recommended.first(5)
    # remove user's already booked tours from these arrays.
    sorted_recommended = convert_to_one_dimensional(sorted_recommended)
    sorted_recommended = remove_already_booked_tours(sorted_recommended,user_tours)
    return sorted_recommended
  end

  def convert_to_one_dimensional(tours)
    recommeded = []
    tours.each do |tour|
      recommeded.push(tour.first)
    end
    return recommeded
  end

  def remove_already_booked_tours(top_rated_tours,current_user_tours)
    current_user_tours.each do |tour|
      top_rated_tours.each do |r_tour|
        if tour.id == r_tour.id
          top_rated_tours.delete(r_tour)
        end
      end
    end
    return top_rated_tours
  end

end