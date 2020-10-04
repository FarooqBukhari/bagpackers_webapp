class CustomTripSerializer < ActiveModel::Serializer
  attributes :id, :seats, :childs, :rooms, :departure_city, :departure_date, :number_of_days
end
