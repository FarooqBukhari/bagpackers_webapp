ActiveAdmin.register TourReview do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :tour_id, :user_id, :rating, :review_text
  #
  # or
  #
  permit_params do
    permitted = [:tour_id, :user_id, :rating, :review_text]
    permitted << :other if params[:action] == 'create' && current_admin_user
    permitted
  end
  
end
