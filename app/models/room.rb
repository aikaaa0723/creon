class Room < ApplicationRecord
  has_many :entries
  has_many :users, through: :entries
  has_many :messages
end

class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :room
end

class User < ApplicationRecord
  has_many :entries
  has_many :rooms, through: :entries
end