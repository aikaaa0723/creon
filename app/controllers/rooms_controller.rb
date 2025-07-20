class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [:show]
  before_action :authorize_room_access!, only: [:show]

  def index
    @rooms = current_user.rooms.includes(:users)
  end

  def show
    @messages = @room.messages.includes(:user)
    @message = Message.new
  end

  def create
    recipient = User.find(params[:user_id])

    # 共通のルームがあるか確認（自分と相手の両方が参加しているルーム）
    existing_room = current_user.rooms.joins(:users)
                          .where(users: { id: recipient.id })
                          .first

    @room = existing_room || Room.create

    if @room.entries.empty?
      Entry.create(user: current_user, room: @room)
      Entry.create(user: recipient, room: @room)
    end

    redirect_to @room
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def authorize_room_access!
    unless @room.users.include?(current_user)
      redirect_to rooms_path, alert: "このDMルームにはアクセスできません。"
    end
  end
end

