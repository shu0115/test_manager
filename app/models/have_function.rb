# coding: utf-8
class HaveFunction < ActiveRecord::Base
  belongs_to :function
  belongs_to :testcase
end
