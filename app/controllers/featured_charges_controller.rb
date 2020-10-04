class FeaturedChargesController < ApplicationController
  rescue_from Stripe::CardError, with: :catch_exception

  def new
    @featured_tour = FeaturedTour.find params[:id]
    if @featured_tour.payment_status?
      redirect_to my_bookings_path(current_user.id)
    else if @featured_tour.user_id != current_user.id
     redirect_to my_bookings_path(current_user.id)
    end
    end
  end

  def create
    StripeChargesServices.new(charges_params, current_user).featured_call
    @featured_tour = FeaturedTour.find params[:id]
    @featured_tour.payment_status = true
    @featured_tour.save

    if @featured_tour.featured_type == "Tour"
    redirect_to @featured_tour.tour
    else
      redirect_to @featured_tour.hotel
    end
  end

  private

  def charges_params
    params.permit(:stripeEmail, :stripeToken, :id)
  end

  def catch_exception(exception)
    flash[:error] = exception.message
  end
end
