class Tweet < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :comments, dependent: :destroy 

  acts_as_taggable_on :tags
  
  validates :image, presence: true
end
