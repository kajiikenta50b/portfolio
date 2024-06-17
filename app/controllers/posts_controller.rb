class PostsController < ApplicationController
  def index
    @posts = Post.include(:user)
  end
end
