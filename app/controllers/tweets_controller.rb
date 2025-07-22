# app/controllers/tweets_controller.rb
class TweetsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @query = params[:query].to_s.strip

    if @query.present?
      session[:search_history] ||= []
      session[:search_history].unshift(@query)
      session[:search_history].uniq!
      session[:search_history] = session[:search_history].take(10)

      keywords = @query.split

      tag = ActsAsTaggableOn::Tag.find_by(name: @query)

      if tag
        @tweets = Tweet.tagged_with(tag.name)
      else
        # AND検索（caption, username, email）
        conditions = keywords.map {
          "(tweets.caption LIKE ? OR users.username LIKE ? OR users.email LIKE ?)"
        }.join(" AND ")

        values = keywords.flat_map { |k| ["%#{k}%", "%#{k}%", "%#{k}%"] }

        @tweets = Tweet.joins(:user).where(conditions, *values)
      end
    else
      @tweets = Tweet.all
    end

  @tweets = @tweets.order(created_at: :desc)
  @popular_tags = ActsAsTaggableOn::Tag.most_used(10)
end

  def show; end
  def new
    @tweet = Tweet.new
  end
  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      redirect_to @tweet, notice: "投稿が作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit; end
  def update
    if @tweet.update(tweet_params)
      redirect_to @tweet, notice: "投稿が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @tweet = Tweet.find(params[:id])
    if @tweet.user == current_user
      @tweet.destroy
      redirect_to tweets_path, notice: '投稿を削除しました'
    else
      redirect_to tweets_path(@tweet), alert: '権限がありません'
    end
  end

  
  def log_view
    @tweet = Tweet.find(params[:id])
    duration = params[:duration].to_i
    ViewLog.create(user: current_user, tweet: @tweet, duration: duration)
    head :ok
  end

  private
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end
  def authorize_user!
    redirect_to tweets_path, alert: "権限がありません。" unless @tweet.user == current_user
  end
  def tweet_params
    params.require(:tweet).permit(:caption, :image, :tag_list)
  end
end
