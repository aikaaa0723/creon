# app/controllers/relationships_controller.rb
class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @user }
    end
  end

  def destroy
    relationship = current_user.active_relationships.find(params[:id])
    @user = relationship.followed
    relationship.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @user }
    end
  end
end
