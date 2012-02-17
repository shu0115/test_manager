# coding: utf-8
class TestcasesController < ApplicationController
  
  #-------#
  # index #
  #-------#
  def index
    @testcases = Testcase.where( project_id: session[:project_id] ).includes( :user ).all
  end

  #------#
  # show #
  #------#
  def show
    @testcase = Testcase.where( id: params[:id], project_id: session[:project_id] ).includes( :user ).first
  end

  #-----#
  # new #
  #-----#
  def new
    @testcase = Testcase.new
  end

  #------#
  # edit #
  #------#
  def edit
    @testcase = Testcase.where( id: params[:id], project_id: session[:project_id] ).includes( :user ).first
  end

  #--------#
  # create #
  #--------#
  def create
    @testcase = Testcase.new( params[:testcase] )
    @testcase.project_id = session[:project_id]
    @testcase.user_id = session[:user_id]
    
    if @testcase.operation_check == "done"
      @testcase.operation_user_id = session[:user_id]
      @testcase.operation_at = Time.now
    end

    if @testcase.save
      redirect_to( { action: "index" }, notice: 'テストケースの作成が完了しました。' )
    else
      render action: "new"
    end
  end

  #--------#
  # update #
  #--------#
  def update
    @testcase = Testcase.where( id: params[:id], project_id: session[:project_id] ).includes( :user ).first

    if @testcase.update_attributes( params[:testcase] )
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
