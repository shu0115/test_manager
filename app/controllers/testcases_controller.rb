# coding: utf-8
class TestcasesController < ApplicationController
  
  #-------#
  # index #
  #-------#
  def index
    # ソート設定生成
    @order, set_order = Testcase.get_order( order_key: params[:order_key], order_sort: params[:order_sort] )
    
    @testcases = Testcase.where( project_id: session[:project_id] ).includes( :user ).includes( :have_functions => :function ).order( set_order ).all
    @project = Project.where( id: session[:project_id] ).first
    
    # 機能名ハッシュ生成
    @function_hash = Hash.new
    functions = Function.where( project_id: session[:project_id] ).select( "id, name" ).all
    functions.each{ |f| @function_hash[f.id] = f.name }
  end

  #------#
  # show #
  #------#
  def show
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
    @testcase = Testcase.new
    @project = Project.where( id: session[:project_id] ).includes( :functions ).first
    @function_level = params[:function_level].presence || Hash.new
  end

  #------#
  # edit #
  #------#
  def edit
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
    
      redirect_to( { action: "index" }, notice: 'テストケースの作成が完了しました。' )
    else
      
      render action: "new"
    end
  end

  #--------#
  # update #
  #--------#
  def update
    @testcase = Testcase.where( id: params[:id], project_id: session[:project_id] ).includes( :user ).includes( :have_functions => :function ).first
    function_level = params[:function_level].presence || Hash.new

    if @testcase.update_attributes( params[:testcase] )
      # 機能階層登録
      @testcase.have_functions.each{ |have_function|
        # 全階層更新
        have_function.update_attributes( function_id: function_level[have_function.level.to_s] )
      }
      
      redirect_to( { action: "index" }, notice: "更新が完了しました。" )
    else
      render action: "edit"
    end
  end

  #--------#
  # delete #
  #--------#
  def delete
    @testcase = Testcase.where( id: params[:id] ).first
    
    if @testcase.destroy
      redirect_to( { action: "index" }, notice: "削除が完了しました。" )
    else
      redirect_to( { action: "index" }, notice: "削除に失敗しました。" )
    end
  end

end
