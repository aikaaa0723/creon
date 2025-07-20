class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  before_action :authorize_room_access!

  def create
    @message = @room.messages.build(message_params.merge(user: current_user))

    respond_to do |format|
      if @message.save
        format.turbo_stream
        format.html { redirect_to @room }
      else
        @messages = @room.messages.includes(:user)
        format.html { render "rooms/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def authorize_room_access!
    unless @room.users.include?(current_user)
      redirect_to rooms_path, alert: "このDMルームにはアクセスできません。"
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
