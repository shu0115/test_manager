# coding: utf-8
class Function < ActiveRecord::Base
  has_many :have_functions
  belongs_to :project
end
