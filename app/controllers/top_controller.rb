# coding: utf-8
class TopController < ApplicationController
  
  #-------#
  # index #
  #-------#
  def index
    @user = User.new
  end
  
  #-------#
  # login #
  #-------#
=begin
  def login
    user = User.new( params[:user] )
    login_user = User.where( login_id: user.login_id, password: user.password ).first
    
    unless login_user.blank?
      session[:user_id] = login_user.id
      redirect_to( { controller: "testcases", action: "index" }, notice: 'ログインが完了しました。' ) and return
    else
      redirect_to( { action: "index" }, alert: '該当するユーザが存在しません。' ) and return
    end
  end
=end
  
  #-----#
  # new #
  #-----#
  def new
    @user = User.new
  end
  
  #-------#
  # entry #
  #-------#
  def entry
    @user = User.new( params[:user] )
    @user.name = "#{@user.last_name} #{@user.first_name}"

    alert_msg = ""
    
    if @user.last_name.blank? or @user.first_name.blank?
      alert_msg += "名前は姓名とも入力して下さい。<br />"
    end
    
    if @user.login_id.blank?
      alert_msg += "ログインIDにメールアドレスを入力して下さい。<br />"
    end
    
    if @user.password.blank? or @user.password_confirmation.blank?
      alert_msg += "パスワードを確認パスワードと共に入力して下さい。<br />"
    end
    
    if @user.password != @user.password_confirmation
      alert_msg += "パスワードが一致しません。<br />"
    end
    
    unless alert_msg.blank?
      flash.now[:alert] = alert_msg
      render action: "new" and return
    end
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to( { controller: "testcases", action: "index" }, notice: 'ユーザ登録が完了しました。' ) and return
    else
      flash.now[:alert] = 'ユーザ登録に失敗しました。'
      render action: "new" and return
    end
  end
  
  #--------#
  # logout #
  #--------#
=begin
  def logout
    session[:user_id] = nil
    session[:project_id] = nil
    
    redirect_to( { action: "index" } ) and return
  end
=end

end
