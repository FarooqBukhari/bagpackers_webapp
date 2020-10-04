class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :email, :sex, :phone_number, :avatar_url, :authentication_token, :about, :cover_url, :location, :dob, :posts_count, :is_admin, :is_trip_organizer, :is_hotel_manager
  # has_one_attached :profile_picture
  # has_one_attached :cover
  has_many :bookings

  def avatar_url
    if(object.profile_picture.attached?)
    return rails_blob_path(object.profile_picture, only_path: true)
    else
      return nil
    end
  end

  def cover_url
    if(object.cover.attached?)
      return rails_blob_path(object.cover, only_path: true)
    else
      return nil
    end
  end


end

