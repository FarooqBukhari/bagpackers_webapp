class TripOrganizerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :company_name, :address, :about, :is_approved, :user_id, :license_url, :company_email, :company_number, :terms, :company_logo_url
  has_many :tours

 def license_url
   if(object.license.attached?)
     return rails_blob_path(object.license, only_path: true)
   else
     return nil
   end
 end

  def company_logo_url
    if(object.company_logo.attached?)
      return rails_blob_path(object.company_logo, only_path: true)
    else
      return nil
    end
  end
end
