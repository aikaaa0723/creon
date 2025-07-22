class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, length: { maximum: 20 }, uniqueness: true

  has_one_attached :avatar

  # 投稿関連
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet
  has_many :comments, dependent: :destroy
  has_many :comment_likes
  has_one_attached :avatar
  # フォロー関連
  has_many :active_relationships, class_name: "Relationship",
           foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # DM関連
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :rooms, through: :entries

  #閲覧画像ジャンル（タグ）を抽出
  has_many :view_logs
  def favorite_tags_by_view_time
    tag_counts = Hash.new(0)

    self.view_logs.includes(tweet: [:tags]).each do |log|
      log.tweet.tags.each do |tag|
        tag_counts[tag.name] += log.duration
      end
    end

    tag_counts.sort_by { |_, time| -time }.to_h
  end

  # app/models/user.rb
  has_one_attached :background_image

  def pixelated_background_url
    return unless background_image.attached?

    # MiniMagickなどでドット変換を済ませた画像を返す想定
    # 仮に変換せずリサイズだけで返すなら：
    Rails.application.routes.url_helpers.rails_representation_url(
      background_image.variant(resize_to_fill: [100, 100]).processed,
      only_path: true
    )
  end
end

