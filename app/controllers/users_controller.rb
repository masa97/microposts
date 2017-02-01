class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :followers, :followings]
  before_action :check_user, only: [:edit, :update]
  before_action :logged_in_user, only: [:index]
    
  def index
   @users = User.paginate(page: 1)
  end
  
  def show
    @microposts = @user.microposts.order(created_at: :desc).page(params[:page]).per(5) 
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end
  
  def followers
    @users = @user.follower_users
  end
  
  def followings
    @users = @user.following_users
  end 
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :location)
  end
  
  def set_user
    @user = User.find(params[:id]) 
  end
  
  def check_user
    if @user != current_user
      redirect_to root_path
      flash[:danger] = "不正を検出しました。別のユーザにはアクセスできません。"
    end
  end
  
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end
