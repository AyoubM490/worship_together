class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user].permit(:name, :email, :password))

    if @user.save
      flash[:success] = "Welcome to the site, #{@user.name}"
      redirect_to users_path
    else
      flash.now[:danger] = "Unable to create new user"
      render "new"
    end
  end
end
