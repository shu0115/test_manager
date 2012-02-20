# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120220022416) do

  create_table "functions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "level"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "have_functions", :force => true do |t|
    t.integer  "testcase_id"
    t.integer  "function_id"
    t.integer  "level"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "function_level"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "testcases", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "title"
    t.text     "page"
    t.text     "operation"
    t.text     "result"
    t.string   "status"
    t.text     "note"
    t.integer  "operation_user_id"
    t.integer  "check_user_id"
    t.datetime "operation_at"
    t.datetime "check_at"
    t.string   "ticket_no"
    t.string   "spec_flag"
    t.string   "os"
    t.string   "browser"
    t.string   "category"
    t.string   "test_user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login_id"
    t.string   "name"
    t.string   "password"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
