class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :content, presence: true
  after_create_commit do
    broadcast_append_to "room_#{room.id}_messages", target: "messages"
  end
end