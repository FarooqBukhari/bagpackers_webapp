ActiveAdmin.register TourismType do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name
  #
  # or
  #
  #
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :name
      f.input :tourism_type_picture, :as => :file, multple: "false"
    end
    f.actions
  end
  permit_params do
    permitted = [:name ,:tourism_type_picture]
    permitted << :other if params[:action] == 'create' && current_admin_user
    permitted
  end

end
