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
      redirect_to user_path(@user)
    else
      flash.now[:danger] = "Unable to create new user"
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
  rescue
    flash[:danger] = "Unable to create new user"
    redirect_to users_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(name: params[:user][:name], email: params[:user][:email], password: params[:user][:password])
    redirect_to user_path(@user)
  end
end
