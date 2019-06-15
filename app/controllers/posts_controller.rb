# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show clap]
  before_action :set_post_preview, only: :preview
  protect_from_forgery with: :null_session, only: :clap

  layout false, only: :preview

  def show; end

  def clap
    respond_to do |format|
      format.html
      format.js do
        if @post.update(clap_count: @post.clap_count + 1)
          render json: {message: 'successful'}, status: :ok
        else
          render json: {message: 'failed'}, status: :internal_server_error
        end
      end
    end
  end

  def preview
    render :preview
  end

  private

  def set_post
    @post = Post.published.friendly.find params[:id]
  end

  def set_post_preview
    @post = Post.new(post_params)
    @post.user = current_admin_user
    @post.created_at = Time.now
    @post.id = 99999
  end

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :cover, :tag, :description, :published)
  end
end
