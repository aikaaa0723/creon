class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :like, :following, :followers]
  before_action :authorize_user!, only: [:edit, :update]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end


  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "プロフィールを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def like
    @liked_tweets = @user.likes.includes(:tweet).map(&:tweet).reverse
  end

  def following
    @users = @user.following
  end

  def followers
    @users = @user.followers
  end

  def search
    if params[:keyword].present?
      @users = User.where("username LIKE ?", "%#{params[:keyword]}%")
    elsif params[:tag].present?
      @users = User.tagged_with(params[:tag])
    else
      @users = User.all
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: "権限がありません。" unless @user == current_user
  end

  def user_params
    params.require(:user).permit(:username, :introduction, :avatar)
  end
end
