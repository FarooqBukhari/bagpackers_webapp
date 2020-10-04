class TourSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :price, :date, :duration, :seats, :image_url, :trip_images_urls, :trip_organizer_id, :bookings_all
  has_many :tour_details
  has_many :tour_reviews
  belongs_to :trip_organizer
  # has_many :bookings, serializer: BookingSerializer

  def bookings_all
    object.bookings.map do |booking|
      ::BookingSerializer.new(booking)
    end
  end


  def image_url
    if(object.image.attached?)
      return rails_blob_path(object.image, only_path: true)
    else
      return nil
    end
  end

  def trip_images_urls
    urls = Array.new(object.trip_images.count)
    urls.each_with_index do |img, index|
      urls[index] = rails_blob_path(object.trip_images[index], only_path: true)
    end
    return urls
  end

end