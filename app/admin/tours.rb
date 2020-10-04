ActiveAdmin.register Tour do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :title, :price, :date, :duration, :seats, :description, :services_included, :services_not_included, :trip_organizer_id, :tourims_type_id, :locations_id
  #
  # or
  #
  permit_params do
    permitted = [:title, :price, :date, :duration, :seats, :description, :services_included, :services_not_included, :trip_organizer_id, :tourims_type_id, :locations_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  
end
