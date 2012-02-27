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
    user = User.where( id: user_id ).select( "name, display_name" ).first
    
    unless user.try(:display_name).blank?
      name = user.display_name
    else
      name = user.try(:name)
    end
    
    return name
  end

  #---------------------------#
  # self.create_with_omniauth #
  #---------------------------#
  def self.create_with_omniauth( auth )
    user = User.new
    user[:provider] = auth["provider"]
    user[:uid] = auth["uid"]
    
    unless auth["info"].blank?
      user[:name] = auth["info"]["name"]
      user[:screen_name] = auth["info"]["nickname"]
      user[:image] = auth["info"]["image"]
    end
    
    user.save
    
    return user
  end

end
