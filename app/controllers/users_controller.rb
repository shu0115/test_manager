# coding: utf-8
class UsersController < ApplicationController
  
  #-------#
  # index #
  #-------#
  def index
    @users = User.order( "created_at DESC" ).limit(1000).all
  end

  #------#
  # edit #
  #------#
  def edit
    @user = User.where( id: params[:id] ).first
    
    unless @user.display_name.blank?
      @user.last_name = @user.display_name.split(" ")[0]
      @user.first_name = @user.display_name.split(" ")[1]
    end
  end

  #--------#
  # update #
  #--------#
  def update
    user_param = params[:user].presence || Hash.new
    @user = User.where( id: params[:id] ).first
    @user.display_name = "#{user_param[:last_name]} #{user_param[:first_name]}"

    if @user.save
      redirect_to( { action: "index" }, notice: 'ユーザ情報の更新が完了しました。')
    else
      render action: "edit"
    end
  end

end
