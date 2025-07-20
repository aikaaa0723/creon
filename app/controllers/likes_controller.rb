class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @tweet = Tweet.find(params[:tweet_id])
    current_user.likes.create(tweet: @tweet)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tweets_path }
    end
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    current_user.likes.find_by(tweet: @tweet)&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tweets_path }
    end
  end
end
