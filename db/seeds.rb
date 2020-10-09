# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# def seed_image(file_name)
#   File.open(File.join(Rails.root, "/app/assets/images/#{file_name}.jpg"))
# end

#location= Location.create ([{name: 'shogran', description: 'Best Place in pak', images: seed_image('insta1')}])

tourism_types = TourismType.create([{name: 'Recreational tourism'},
                                    {name: 'Environmental tourism'},
                                    {name: 'Historical tourism'},
                                    {name: 'Ethnic tourism'},
                                    {name: 'Cultural tourism'},
                                    {name: 'Adventure tourism'},
                                    {name: 'Health tourism'},
                                   {name: 'Religious tourism'},
                                    {name: 'Music tourism'},
                                    {name: 'Wild life tourism'}])
hotel_facility_names = HotelFacilityName.create([{name: 'Parking'},
                                                 {name: 'Wifi'},
                                                 {name: 'Pool'},
                                                 {name: 'Playground'},
                                                 {name: 'Mess'},
                                                 {name: 'Shop'},
                                                 {name: 'Laundary'},
                                                 {name: 'Gym'},
                                                 {name: 'Room Service'},
                                                 {name: 'Hot Water'},
                                                 {name: 'Security Cameras'},
                                                 {name: 'Electricity Backup'}])
hotel_room_facility_names = HotelRoomFacility.create([{name: 'Heater'},
                                                 {name: 'Air Conditioned'},
                                                 {name: 'TV'},
                                                 {name: 'Kitchenette'},
                                                 {name: 'Refrigerator'},
                                                 {name: 'Microwave'}])
AdminUser.create!(email: 'haristanveer.ht@gmail.com', password: '123456', password_confirmation: '123456') if Rails.env.development?