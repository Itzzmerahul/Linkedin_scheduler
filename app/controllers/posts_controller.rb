# app/controllers/posts_controller.rb

class PostsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts
  def index
    # Only show posts belonging to the current user
    @posts = current_user.posts.order(created_at: :desc)
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      # Enqueue publish job if scheduled
      if @post.status == 'scheduled' && @post.publish_at.present?
        PostPublisherJob.set(wait_until: @post.publish_at).perform_later(@post)
      end
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      # Enqueue publish job if scheduled
      if @post.status == 'scheduled' && @post.publish_at.present?
        PostPublisherJob.set(wait_until: @post.publish_at).perform_later(@post)
      end
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post was successfully destroyed."
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      # Find the post ONLY from within the current user's posts
      @post = current_user.posts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to posts_path, alert: "Post not found."
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:content, :publish_at, :status)
    end
end
