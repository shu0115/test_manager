# coding: utf-8
class Testcase < ActiveRecord::Base

  has_many :have_functions
  belongs_to :user

#  validates :title, :presence => true

  attr_accessor :operation_check
  attr_accessor :amend_check
  
  #----------------------#
  # operation_check_done #
  #----------------------#
  # 実施有無チェック
  def operation_check_done?
    if !self.operation_user_id.blank? and !self.operation_at.blank?
      return true
    else
      return false
    end
  end
  
  #------------------#
  # amend_check_done #
  #------------------#
  # 対応有無チェック
  def amend_check_done?
    if !self.check_user_id.blank? and !self.check_at.blank?
      return true
    else
      return false
    end
  end
  
  private
  
  #-----------------#
  # self.set_filter #
  #-----------------#
  # フィルタ機能
  def self.set_filter( args )
    testcases = args[:testcases]
    set_filter = args[:set_filter]
    have_ids = Array.new
    first_flag = 1
    have_function_flag = 0

    set_filter.each_pair{ |key, value|
      unless value.blank?
        # キーが機能階層であれば
        if key == "function_level"
          value.each_pair{ |key2, value2|
            unless value2.blank?
              get_ids = HaveFunction.where( function_id: value2, level: key2 ).uniq.pluck( :testcase_id )
              
              # OPTIMIZE: have_idsのblank?判定では初期値の空欄と機能階層フィルタ結果による空欄の区別が付かないためfirst_flagにより初期値空欄を判別(初期値の場合は配列のAND演算をせずそのまま取得したidを配列に格納する) 2012/02/21 Shun Matsumoto
              if first_flag == 1
                have_ids = get_ids
                first_flag = 0
                have_function_flag = 1
              else
                # 配列のAND演算
                have_ids &= get_ids
              end
            end
          }
        elsif key == "ticket_no"
          if value == "有り"
            testcases = testcases.where( "ticket_no IS NOT NULL AND ticket_no != ''" )
          elsif value == "無し"
            testcases = testcases.where( "ticket_no IS NULL OR ticket_no = ''" )
          end
        else
          testcases = testcases.where( "#{key} = :#{key}", { key => value }.symbolize_keys )
        end
      end
    }
    
    # OPTIMIZE:初期値の空欄か機能階層フィルタ後の空欄かを判別するためにhave_function_flag条件を指定している 2012/02/21 Shun Matsumoto
    if !have_ids.blank? or have_function_flag == 1
      testcases = testcases.where( id: have_ids )
    end
    
    return testcases
  end
  
  #-----------------#
  # self.set_search #
  #-----------------#
  # 検索機能
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
  # ソート機能
  def self.set_order( args )
    order = Hash.new{ |hash, key| hash[key] = Hash.new }
    param_order = args[:order].presence || Hash.new
    order[:key] = param_order[:key].presence || "created_at"
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
    order_sort[:id] = "ASC"
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

  #------------#
  # self.to_br #
  #------------#
  def self.to_br( target )
    return target.gsub("\r\n", "<br />")
  end
  
  #------------------#
  # self.judge_count #
  #------------------#
  def self.judge_count( testcases )
    count_hash = Hash.new
    count_hash[:ok] = testcases.where( judge: "OK" ).count
    count_hash[:pending] = testcases.where( judge: "Pending" ).count
    count_hash[:ng] = testcases.where( judge: "NG" ).count
    
    return count_hash
  end

end
