# Copyright (c) 2015, @sudharti(Sudharsanan Muralidharan)
# Socify is an Open source Social network written in Ruby on Rails This file is licensed
# under GNU GPL v2 or later. See the LICENSE.

class FeedController < ApplicationController
  before_action :set_user, except: :front
  respond_to :html, :js
  before_action :authenticate_user!

  def index
    return redirect_to home_path if !current_user
    @blogs = Blog.limit(5).order(created_at: :DESC)
    @post = Post.new
    @friends = @user.all_following.unshift(@user)
    @activities = PublicActivity::Activity.where(owner_id: @friends).where(trackable_type: 'Post').where(key: 'post.create').order(created_at: :desc).paginate(page: params[:page], per_page: 3)
    render :layout => 'user_feed_profile'
      # respond_to :js, render: :index
  end

  def front
    @activities = PublicActivity::Activity.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    render :layout => 'user_feed_profile'
  end

  def find_friends
    @friends = @user.all_following
    @users =  User.where.not(id: @friends.unshift(@user)).paginate(page: params[:page])
    render :layout => 'user_feed_profile'
  end

  private
  def set_user
    @user = current_user
  end
end
