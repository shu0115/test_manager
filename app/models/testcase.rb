# coding: utf-8
class Testcase < ActiveRecord::Base
  belongs_to :user
  
  attr_accessor :operation_check
end
