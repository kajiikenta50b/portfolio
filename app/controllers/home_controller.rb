class HomeController < ApplicationController
  skip_before_action :require_login, only: %i[ top ]

  def top
    @q = Post.ransack(params[:q])
    @posts = @q.result.includes(:user).order(created_at: :desc)
    @top_faction = TopFaction.last_week_top_faction
  end
end
