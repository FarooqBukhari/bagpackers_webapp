ActiveAdmin.register TripOrganizer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :company_name, :address, :about, :cancellation_policy, :url, :is_approved, :user_id, :company_email, :company_number, :terms
  #
  # or
  #
  permit_params do
    permitted = [:company_name, :address, :about, :cancellation_policy, :url, :is_approved, :user_id, :company_email, :company_number, :terms]
    permitted << :other if params[:action] == 'create' && current_admin_user
    permitted
  end
  
end
