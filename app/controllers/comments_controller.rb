class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = params[:parent_id] if params[:parent_id].present?

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @tweet, notice: "コメントを追加しました。" }
      end
    else
      redirect_to @tweet, alert: "コメントの投稿に失敗しました。"
    end
  end

  def edit
  @comment = Comment.find(params[:id])
  redirect_to @comment.tweet, alert: "権限がありません" unless @comment.user == current_user
end

def update
  @comment = Comment.find(params[:id])
  if @comment.user == current_user && @comment.update(comment_params)
    redirect_to @comment.tweet, notice: "コメントを更新しました"
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @comment = Comment.find(params[:id])
  tweet = @comment.tweet
  if @comment.user == current_user
    @comment.destroy
    redirect_to tweet, notice: "コメントを削除しました"
  else
    redirect_to tweet, alert: "削除権限がありません"
  end
end


  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end