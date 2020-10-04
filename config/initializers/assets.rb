# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile += %w( welcome.css welcome.js )
Rails.application.config.assets.precompile += %w( devise/sessions.css devise/sessions.js )
Rails.application.config.assets.precompile += %w( devise/registrations.css devise/registrations.js )
Rails.application.config.assets.precompile += %w( about.css about.js )
Rails.application.config.assets.precompile += %w( contact.css contact.js )
Rails.application.config.assets.precompile += %w( custom_trips.css custom_trips.js )
Rails.application.config.assets.precompile += %w( blogs.css blogs.js )
Rails.application.config.assets.precompile += %w( users.css users.js )
Rails.application.config.assets.precompile += %w( tours.css tours.js )
Rails.application.config.assets.precompile += %w( dashboard/tours.css dashboard/tours.js )
Rails.application.config.assets.precompile += %w( dashboard/tour_details.css dashboard/tour_details.js )
Rails.application.config.assets.precompile += %w( feed.css feed.js )
Rails.application.config.assets.precompile += %w( posts.css posts.js )
Rails.application.config.assets.precompile += %w( hotels.css hotels.js )
Rails.application.config.assets.precompile += %w( dashboard/hotels.css dashboard/hotels.js )
Rails.application.config.assets.precompile += %w( hotel_rooms.css hotel_rooms.js )
Rails.application.config.assets.precompile += %w( locations.css locations.js )
Rails.application.config.assets.precompile += %w( hotel_managers.css hotel_managers.js )
Rails.application.config.assets.precompile += %w( dashboard/hotel_managers.css dashboard/hotel_managers.js )
Rails.application.config.assets.precompile += %w( charges.css charges.js )
Rails.application.config.assets.precompile += %w( featured_charges.css featured_charges.js )
Rails.application.config.assets.precompile += %w( posts.css posts.js )
Rails.application.config.assets.precompile += %w( trip_organizers.css trip_organizers.js )
Rails.application.config.assets.precompile += %w( dashboard/trip_organizers.css dashboard/trip_organizers.js )
Rails.application.config.assets.precompile += %w( messages.css messages.js )
Rails.application.config.assets.precompile += %w( filterrific/filterrific-spinner.gif )
Rails.application.config.assets.precompile += %w( car_rental_owners.css car_rental_owners.js )
Rails.application.config.assets.precompile += %w( car_rentals.css car_rentals.js )
Rails.application.config.assets.precompile += %w( dashboard/car_rental_owners.css dashboard/car_rental_owners.js )
Rails.application.config.assets.precompile += %w( vehicles.css vehicles.js )
Rails.application.config.assets.precompile += %w( notifications/notifications.css notifications/notifications.js )
Rails.application.config.assets.precompile += %w( devise/passwords.js devise/passwords.css )
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
