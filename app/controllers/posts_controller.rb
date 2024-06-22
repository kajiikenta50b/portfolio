class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, success: '投稿が完了しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :post_image_cache)
  end
end
