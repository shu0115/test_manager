# coding: utf-8
class UsersController < ApplicationController
  
  #-------#
  # index #
  #-------#
  def index
    @users = User.order( "created_at DESC" ).limit(1000).all
  end
  
end
