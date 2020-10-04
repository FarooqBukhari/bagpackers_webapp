ActiveAdmin.register HotelManager do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_id, :company_name, :is_approved
  #
  # or
  #
  permit_params do
    permitted = [:user_id, :company_name, :is_approved]
    permitted << :other if params[:action] == 'create' && current_admin_user
    permitted
  end
  
end
