class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :footer_trip
  helper_method :footer_location
  helper_method :footer_hotels
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :username, :profile_picture,:phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :username,:profile_picture, :phone])
  end

  def is_admin?
    redirect_to root_path unless current_user.is_admin?
  end

  def footer_trip
     Tour.order(Arel.sql('RANDOM()')).first(3)
  end
  def footer_hotels(location_id)
     Hotel.where(locations_id: location_id).first(3)
  end
  def footer_location
     Location.order(Arel.sql('RANDOM()')).first(3)
  end

end
