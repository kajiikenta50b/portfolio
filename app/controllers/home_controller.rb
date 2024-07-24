class HomeController < ApplicationController
  skip_before_action :require_login, only: %i[ top ]

  def top
    @q = Post.ransack(params[:q])
    @posts = @q.result.includes(:user).order(created_at: :desc)
    top_faction_symbol = TopFaction.last_week_top_faction
    @top_faction = User.factions_i18n[top_faction_symbol] if top_faction_symbol.present?
  end
end