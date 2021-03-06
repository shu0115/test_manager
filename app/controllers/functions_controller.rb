# coding: utf-8
class FunctionsController < ApplicationController
  
  #-------#
  # index #
  #-------#
  def index
    @level = params[:level]
    
    @functions = Function.where( project_id: session[:project_id] )
    
    unless @level.blank?
      @functions = @functions.where( level: @level )
    end
    
    @project = Project.where( id: session[:project_id] ).first
  end

  #-----#
  # new #
  #-----#
  def new
    @function = Function.new
    @function.level = 1
    
    @project = Project.where( id: session[:project_id] ).first
    
    @levels = Array.new
    1.upto(@project.function_level){ |level| @levels.push(level) }
    
    @level = params[:level]
  end

  #------#
  # edit #
  #------#
  def edit
    @function = Function.where( id: params[:id] ).first
    
    @project = Project.where( id: session[:project_id] ).first
    
    @levels = Array.new
    1.upto(@project.function_level){ |level| @levels.push(level) }
    
    @level = @function.level
  end

  #--------#
  # create #
  #--------#
  def create
    @function = Function.new(params[:function])
    @function.user_id = session[:user_id]
    @function.project_id = session[:project_id]

    if @function.save
      redirect_to( { action: "index", level: params[:level] }, notice: '機能名の作成が完了しました。' )
    else
      render action: "new"
    end
  end

  #--------#
  # update #
  #--------#
  def update
    @function = Function.find(params[:id])

    if @function.update_attributes(params[:function])
      redirect_to( { action: "index", level: params[:level] }, notice: '機能名の更新が完了しました。')
    else
      render action: "edit"
    end
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    @function = Function.find(params[:id])
    @function.destroy

    redirect_to( { action: "index", level: params[:level] }, notice: "削除が完了しました。" )
  end
end
