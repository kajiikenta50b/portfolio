class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    def create
      @user = login(params[:email], params[:password])

      if @user
        redirect_to root_path
      else
        render :new
      end
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other
  end
end
