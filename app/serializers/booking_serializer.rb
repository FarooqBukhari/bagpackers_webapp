class BookingSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :tour_id, :no_of_seats, :payment_status, :payment_amount
  belongs_to :user
end