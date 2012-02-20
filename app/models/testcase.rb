# coding: utf-8
class Testcase < ActiveRecord::Base
  has_many :have_functions
  belongs_to :user

#  validates :title, :presence => true

  attr_accessor :operation_check
  
  private
  
  #----------------#
  # self.get_order #
  #----------------#
  def self.get_order( args )
    order_key = args[:order_key].presence || "operation_at"
    order_sort = args[:order_sort].presence || "DESC"

    order = Hash.new{ |hash, key| hash[key] = Hash.new }
    
    # ソート順設定
    order[:sort] = Testcase.set_default_sort( order_key, order_sort )
    if order[:sort][order_key.to_sym] == "ASC"
      order[:sort][order_key.to_sym] = "DESC"
    else
      order[:sort][order_key.to_sym] = "ASC"
    end

    # ソートマーク設定
    order[:mark] = Testcase.set_mark( order_key, order_sort )

    set_order = "#{order_key} #{order_sort}"
    
    return order, set_order
  end
  
  #-----------------------#
  # self.set_default_sort #
  #-----------------------#
  def self.set_default_sort( now_key, now_sort )
    order_sort = Hash.new
    order_sort[:title] = "ASC"
    order_sort[:status] = "ASC"
    order_sort[:operation_user_id] = "ASC"
    order_sort[:operation_at] = "ASC"
    order_sort[:page] = "ASC"
    order_sort[:operation] = "ASC"
    order_sort[:result] = "ASC"
    order_sort[:status] = "ASC"
    order_sort[:ticket_no] = "ASC"
    order_sort[:spec_flag] = "ASC"
    order_sort[:check_at] = "ASC"
    order_sort[:check_user_id] = "ASC"
    order_sort[:note] = "ASC"
    
    # クリックされたソート指定で上書き
    order_sort[now_key.to_sym] = now_sort
    
    return order_sort
  end
  
  #---------------#
  # self.set_mark #
  #---------------#
  def self.set_mark( now_key, now_sort )
    order_mark = Hash.new
    
    if now_sort == "ASC"
      order_mark[now_key.to_sym] = "▲"
    else
      order_mark[now_key.to_sym] = "▼"
    end
    
    return order_mark
  end

end
