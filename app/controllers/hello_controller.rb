class HelloController < ApplicationController
  def index
    return redirect_to new_user_session_path unless current_user
    following_ids = current_user.following.pluck(:id)
    @following_tweets = Tweet.includes(:user).where(user_id: following_ids).order(created_at: :desc).limit(10)

    # 閲覧ジャンル上位のタグを抽出
    top_tags = current_user.favorite_tags_by_view_time.keys.take(3)

    # 滞在時間・ジャンルベース
    @recommended_tweets = Tweet.joins(:tags)
      .where(tags: { name: top_tags })
      .where.not(user_id: following_ids + [current_user.id])
      .distinct
      .order("RANDOM()")
      .limit(10)

    # いいねベースのおすすめ（例：過去にいいねした投稿の作者の他投稿）
    liked_user_ids = current_user.liked_tweets.pluck(:user_id).uniq
    @liked_based_recommendations = Tweet.includes(:user)
      .where(user_id: liked_user_ids)
      .where.not(user_id: following_ids + [current_user.id])
      .order("RANDOM()")
      .limit(10)
  end
end