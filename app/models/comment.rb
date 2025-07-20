class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  # モデルクラス名を明示する
  has_many :comment_likes, class_name: "CommentLike", dependent: :destroy

  # スレッド型コメント機能
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
end
