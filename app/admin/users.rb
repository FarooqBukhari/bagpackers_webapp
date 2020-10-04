ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :name, :about, :profile_picture, :cover, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sex, :location, :dob, :phone_number, :posts_count, :slug, :is_admin, :is_trip_organizer, :is_hotel_manager, :authentication_token, :stripe_id
  #
  # or
  #
  permit_params do
    permitted = [:email, :encrypted_password, :name, :about, :profile_picture, :cover, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sex, :location, :dob, :phone_number, :posts_count, :slug, :is_admin, :is_trip_organizer, :is_hotel_manager, :authentication_token, :stripe_id]
    permitted << :other if params[:action] == 'create' && current_admin_user
    permitted
  end
  
end
