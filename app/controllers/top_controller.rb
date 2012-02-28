# coding: utf-8
class TopController < ApplicationController
  
  #-------#
  # index #
  #-------#
  def index
    @user = User.new
  end

end
