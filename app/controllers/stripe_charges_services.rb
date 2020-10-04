class StripeChargesServices
  DEFAULT_CURRENCY = 'pkr'.freeze

  def initialize(params, user)
    @stripe_email = params[:stripeEmail]
    @stripe_token = params[:stripeToken]
    @booking = params[:id]
    @user = user
  end

  def call
    create_charge(find_customer)
  end

  def featured_call
    create_featured_charge(find_customer)
  end

  private

  attr_accessor :user, :stripe_email, :stripe_token, :booking

  def find_customer
    if user.stripe_id
      retrieve_customer(user.stripe_id)
    else
      create_customer
    end
  end

  def retrieve_customer(stripe_token)
    Stripe::Customer.retrieve(stripe_token)
  end

  def create_customer
    customer = Stripe::Customer.create(
        email: stripe_email,
        source: stripe_token
    )
    user.update(stripe_id: customer.id)
    customer
  end

  def create_charge(customer)
    Stripe::Charge.create(
        customer: customer.id,
        amount: order_amount,
        description: "Booking for tour with tour_id" + Booking.find_by(id: @booking).tour_id.to_s + " for no of seats :"+Booking.find_by(id: @booking).no_of_seats.to_s,
        currency: 'pkr'
    )
  end

  def create_featured_charge(customer)
    @featured = FeaturedTour.find_by(id: @booking)
    if @featured.featured_type == "Tour"
      Stripe::Charge.create(
          customer: customer.id,
          amount: @featured.payment_amount * 100,
          description: "Payment for tour featuring, tour_id :" + FeaturedTour.find(@booking).tour_id.to_s,
          currency: 'pkr'
      )
    else
      Stripe::Charge.create(
          customer: customer.id,
          amount: @featured.payment_amount * 100,
          description: "Payment for Hotel featuring, hotel_id :" + FeaturedTour.find(@booking).hotels_id.to_s,
          currency: 'pkr'
      )
    end
  end

  def order_amount
    Booking.find_by(id: @booking).payment_amount * 100
  end
  def featured_order_amount
    FeaturedTour.find_by(id: @booking).payment_amount * 100
  end
end