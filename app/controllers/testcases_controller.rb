# coding: utf-8
class TestcasesController < ApplicationController
  
  #-------#
  # index #
  #-------#
  def index
    # 表示項目設定
    if params[:commit] == "リセット"
      @display = Hash.new{ |hash, key| hash[key] = "true" }
      session[:display] = Hash.new
    else
      @display = params[:display].presence || session[:display].presence || Hash.new{ |hash, key| hash[key] = "true" }
      session[:display] = params[:display] unless params[:display].blank?
    end

    # 初期条件設定
    @testcases = Testcase.where( project_id: session[:project_id] ).includes( :user ).includes( :have_functions => :function )

    # ソート設定生成
    @order, set_order = Testcase.set_order( order: params[:order] )
    
    # フィルタ条件追加
    @set_filter = params[:set_filter].presence || Hash.new{ |hash, key| hash[key] = Hash.new }
    @testcases = Testcase.set_filter( testcases: @testcases, set_filter: @set_filter )
    
    # 検索
    @search = params[:search].presence || Hash.new
    @testcases = Testcase.set_search( testcases: @testcases, search: @search, set_order: set_order )
    
    # 判定カウント集計
    @judge_count_hash = Testcase.judge_count( @testcases )
    
    # ページング
    @testcases = @testcases.page( params[:page] ).per( PER_PAGE )

    # 機能名ハッシュ生成
    @function_hash = Hash.new
    functions = Function.where( project_id: session[:project_id] ).select( "id, name" ).all
    functions.each{ |f| @function_hash[f.id] = f.name }
    
    # 名前配列取得
#    @user_names = User.uniq.order( "name ASC" ).select( "id, name" )
    @user_names = User.uniq.order( "display_name ASC" ).select( "id, display_name" )

    # プロジェクト取得
    @project = Project.where( id: session[:project_id] ).first
    
    # 機能名取得
    @functions = Hash.new
    1.upto(@project.function_level){ |level|
      @functions[level] = Function.where( project_id: session[:project_id], level: level ).uniq.order( "name ASC" ).select( "id, name" )
    }
  end

  #------#
  # show #
  #------#
  def show
    @order = params[:order]
    @search = params[:search]
    @set_filter = params[:set_filter]
    @display = params[:display]
    
    @testcase = Testcase.where( id: params[:id], project_id: session[:project_id] ).includes( :user ).includes( :have_functions => :function ).first
    @project = Project.where( id: session[:project_id] ).includes( :functions ).first
    
    # 機能階層ハッシュ生成
    @have_functions = Hash.new
    @testcase.have_functions.each{ |h| @have_functions[h.level] = h.function.try(:name) }
  end

  #-----#
  # new #
  #-----#
  def new
    @order = params[:order]
    @search = params[:search]
    @set_filter = params[:set_filter]
    @display = params[:display]
    
    @testcase = Testcase.new
    @project = Project.where( id: session[:project_id] ).includes( :functions ).first
    @function_level = params[:function_level].presence || Hash.new
  end

  #------#
  # edit #
  #------#
  def edit
    @order = params[:order]
    @search = params[:search]
    @set_filter = params[:set_filter]
    @display = params[:display]
    
    @testcase = Testcase.where( id: params[:id], project_id: session[:project_id] ).includes( :user ).includes( :have_functions => :function ).first
    @project = Project.where( id: session[:project_id] ).includes( :functions ).first
    
    @have_functions = Hash.new
    @testcase.have_functions.each{ |h| @have_functions[h.level] = { id: h.function_id, name: h.function.try(:name) } }
  end

  #--------#
  # create #
  #--------#
  def create
    @project = Project.where( id: session[:project_id] ).includes( :functions ).first
    @function_level = params[:function_level].presence || Hash.new
      
    @testcase = Testcase.new( params[:testcase] )
    @testcase.project_id = session[:project_id]
    @testcase.user_id = session[:user_id]
    
    # 実施チェック
    if @testcase.operation_check == "done"
      @testcase.operation_user_id = session[:user_id]
      @testcase.operation_at = Time.now
    end

    if @testcase.save
      # 機能階層登録
      params[:function_level].each_pair{ |key, value|
        # 全階層作成
        HaveFunction.create( testcase_id: @testcase.id, function_id: value, level: key )
      }
    
      redirect_to( { action: "index", order: params[:order], search: params[:search], set_filter: params[:set_filter], display: params[:display] }, notice: 'テストケースの作成が完了しました。' )
    else
      @order = params[:order]
      @search = params[:search]
      @set_filter = params[:set_filter]
      render action: "new"
    end
  end

  #--------#
  # update #
  #--------#
  def update
    @testcase = Testcase.where( id: params[:id], project_id: session[:project_id] ).includes( :user ).includes( :have_functions => :function ).first
    function_level = params[:function_level].presence || Hash.new
    update_testcase = params[:testcase].presence || Hash.new
    
    # 実施チェック
    if update_testcase[:operation_check] == "done"
      update_testcase[:operation_user_id] = session[:user_id]
      update_testcase[:operation_at] = Time.now
    end

#    if @testcase.update_attributes( params[:testcase] )
    if @testcase.update_attributes( update_testcase )
      # 機能階層更新
      unless function_level.blank?
        @testcase.have_functions.each{ |have_function|
          # 全階層更新
          have_function.update_attributes( function_id: function_level[have_function.level.to_s] )
        }
      end
      
#      redirect_to( { action: "index", order: params[:order], search: params[:search], set_filter: params[:set_filter], display: params[:display] }, notice: "更新が完了しました。" )
      redirect_to( { action: "show", id: @testcase.id, order: params[:order], search: params[:search], set_filter: params[:set_filter], display: params[:display] }, notice: "更新が完了しました。" )
    else
      @order = params[:order]
      @search = params[:search]
      @set_filter = params[:set_filter]
      render action: "edit"
    end
  end

  #--------#
  # delete #
  #--------#
  def delete
    @testcase = Testcase.where( id: params[:id] ).first
    
    if @testcase.destroy
      msg = "削除が完了しました。"
    else
      msg = "削除に失敗しました。"
    end
    
    redirect_to( { action: "index", order: params[:order], search: params[:search], set_filter: params[:set_filter], display: params[:display] }, notice: msg )
  end

end
