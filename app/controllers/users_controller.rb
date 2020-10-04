# Copyright (c) 2015, @sudharti(Sudharsanan Muralidharan)
# Socify is an Open source Social network written in Ruby on Rails This file is licensed
# under GNU GPL v2 or later. See the LICENSE.

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, except: [:delete]
  before_action :check_ownership, only: [:edit, :update]
  respond_to :html, :js


  def trip_organizer_request
    @user.is_trip_organizer = true
  end

  def my_bookings
    @bookings = @user.bookings.paginate(:per_page => 2, :page => params[:page])
    render :layout => 'user_feed_profile'
  end
  def show
    @blogs = Blog.limit(5).order(created_at: :DESC)
    @post = Post.new
    @activities = PublicActivity::Activity.where(owner: @user).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    render :layout => 'user_feed_profile'
  end

  def edit
    render :layout => 'user_feed_profile'
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def deactivate
    render :layout => 'user_feed_profile'
  end

  def friends
    @friends = @user.following_users.paginate(page: params[:page])
    render :layout => 'user_feed_profile'
  end

  def followers
    @followers = @user.user_followers.paginate(page: params[:page])
    render :layout => 'user_feed_profile'
  end

  def mentionable
    render json: @user.following_users.as_json(only: [:id, :name]), root: false
  end

  private

  def user_params
    params.require(:user).permit(:name, :about, :profile_picture, :cover,
                                 :sex, :dob, :location, :phone_number)
  end

  def check_ownership
    redirect_to current_user, notice: 'Not Authorized' unless @user == current_user
  end

  def set_user
    @user = User.find(params[:id])
  end
end
render :layout => false
