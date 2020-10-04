require './lib/disco_task.rb'
class Booking < ApplicationRecord

  belongs_to :user
  belongs_to :tour
  validates_presence_of :no_of_seats
  validates_numericality_of :user_id
  validates_numericality_of :tour_id
  validates_numericality_of :payment_amount

  after_commit :create_notifications, on: :create
  include DiscoTask
  private

  def create_notifications
    Notification.create do |notification|
      notification.notify_type = 'booking'
      notification.actor = self.user
      notification.user = self.tour.trip_organizer.user
      notification.target = self
      notification.second_target = self.tour
    end
    perform
  end
end
