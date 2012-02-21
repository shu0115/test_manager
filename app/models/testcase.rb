# coding: utf-8
class Testcase < ActiveRecord::Base
  has_many :have_functions
  belongs_to :user

#  validates :title, :presence => true

  attr_accessor :operation_check
  
  private
  
  #-----------------#
  # self.set_filter #
  #-----------------#
  def self.set_filter( args )
    testcases = args[:testcases]
    set_filter = args[:set_filter]
    
    set_filter.each_pair{ |key, value|
      unless value.blank?
        if key == "function_level"
          value.each_pair{ |key2, value2|
            unless value2.blank?
              have_ids = HaveFunction.where( function_id: value2, level: key2 ).uniq.pluck( :testcase_id )
              testcases = testcases.where( id: have_ids )
            end
          }
        else
          testcases = testcases.where( "#{key} = :#{key}", { key => value }.symbolize_keys )
        end
      end
    }
    
    return testcases
  end
  
  #-----------------#
  # self.set_search #
  #-----------------#
  def self.set_search( args )
    search = args[:search].presence || Hash.new
    set_order = args[:set_order]
    
    testcases = args[:testcases]
    
    if !search[:target].blank? and !search[:word].blank?
      condition = [ "#{search[:target]} LIKE :#{search[:target]}", { search[:target] => "%#{search[:word]}%" }.symbolize_keys ]
      testcases = testcases.where( condition ).order( set_order )
    else
      testcases = testcases.order( set_order )
    end
    
    return testcases
  end
  
  #----------------#
  # self.set_order #
  #----------------#
  def self.set_order( args )
    order = Hash.new{ |hash, key| hash[key] = Hash.new }
    param_order = args[:order].presence || Hash.new
    order[:key] = param_order[:key].presence || "operation_at"
    order[:sort] = param_order[:sort].presence || "DESC"

    # ソート順設定
    order[:item] = Testcase.set_default_sort( order )
    
    if order[:item][order[:key].to_sym] == "ASC"
      order[:item][order[:key].to_sym] = "DESC"
    else
      order[:item][order[:key].to_sym] = "ASC"
    end

    # ソートマーク設定
    order[:mark] = Testcase.set_mark( order )

    set_order = "#{order[:key]} #{order[:sort]}"
    
    return order, set_order
  end
  
  #-----------------------#
  # self.set_default_sort #
  #-----------------------#
  def self.set_default_sort( order )
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
    order_sort[order[:key].to_sym] = order[:sort]
    
    return order_sort
  end
  
  #---------------#
  # self.set_mark #
  #---------------#
  def self.set_mark( order )
    order_mark = Hash.new
    
    if order[:sort] == "ASC"
      order_mark[order[:key].to_sym] = "▲"
    else
      order_mark[order[:key].to_sym] = "▼"
    end
    
    return order_mark
  end

end
