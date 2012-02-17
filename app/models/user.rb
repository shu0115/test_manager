# coding: utf-8
class User < ActiveRecord::Base
  
  has_many :testcases
  
  attr_accessor :last_name
  attr_accessor :first_name
  attr_accessor :password_confirmation
  
  private
  
  #---------------#
  # self.get_name #
  #---------------#
  def self.get_name( user_id )
    user = User.where( id: user_id ).select( :name ).first
    return user.try(:name)
  end

end
