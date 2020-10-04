# Copyright (c) 2015, @sudharti(Sudharsanan Muralidharan)
# Socify is an Open source Social network written in Ruby on Rails This file is licensed
# under GNU GPL v2 or later. See the LICENSE.

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]


  def show
    @comments = @post.comments.all
    render :layout => 'user_feed_profile'
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.save
    @activity = PublicActivity::Activity.where(trackable_id: @post.id)[0]
    if !request.xhr?
      redirect_to feed_path
    end
    #   redirect_to feed_path
    # else
    #   redirect_to feed_path, notice: @post.errors.full_messages.first
  end


  def edit
    @activity = PublicActivity::Activity.where(trackable_id: @post.id)[0]
    @user = current_user
    render :layout => 'user_feed_profile'
  end

  def update
    @activity = PublicActivity::Activity.where(trackable_id: @post.id)[0]
    @post.update(post_params)
    redirect_to feed_path
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end

  def delete_image_attachment
    @post = Post.find params[:post_id]
    @post.attachment.purge
   # redirect_back(fallback_location: request.referer)
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :attachment)
  end
end