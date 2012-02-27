class ApplicationController < ActionController::Base
  protect_from_forgery

  # セッション有効期限延長
  before_filter :reset_session_expires

  # 未ログインリダイレクト
  before_filter :authorize

  # プロジェクト取得
  before_filter :get_project

  private

  #-----------------------#
  # reset_session_expires #
  #-----------------------#
  # セッション期限延長
  def reset_session_expires
    request.session_options[:expire_after] = 2.weeks
  end
  
  #--------------#
  # current_user #
  #--------------#
  def current_user
    @current_user ||= User.where( id: session[:user_id] ).first
  end
  
  helper_method :current_user

  #-----------#
  # authorize #
  #-----------#
  # ログイン認証
  def authorize
    if params[:controller] == "top" and params[:action] == "index"
      # トップページでログイン済みであれば
      unless session[:user_id].blank?
        redirect_to :controller => "testcases", :action => "index" and return
      end
    elsif params[:controller] != "top" and params[:controller] != "sessions"
      # トップページ以外で未ログインであればトップヘリダイレクト
      if session[:user_id].blank?
        redirect_to :root and return
      end
    end
  end

  #-------------#
  # get_project #
  #-------------#
  # プロジェクト取得
  def get_project
    if session[:project_id].blank?
      project = Project.first
      session[:project_id] = project.id
      session[:project_name] = project.name
    end
  end

end
