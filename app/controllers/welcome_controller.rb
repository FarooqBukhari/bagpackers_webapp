class WelcomeController < ApplicationController
    def index
        if user_signed_in?
            u = current_user
            @recommended_tours = u.recommended_tours
        end
        @tours = Tour.limit(6)
        @locations = Location.limit(6)
        @hotels = Hotel.limit(6)
        @blogs = Blog.limit(3)
        @tourism_types= TourismType.limit(10)
    end
end
