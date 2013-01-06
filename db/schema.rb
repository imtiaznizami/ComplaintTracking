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

ActiveRecord::Schema.define(:version => 20130106112419) do

  create_table "addresses", :force => true do |t|
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "line"
    t.string   "area_name"
    t.string   "postal_code"
    t.string   "city"
    t.string   "union_council"
    t.string   "tehsil"
    t.string   "district"
    t.string   "province"
    t.string   "region"
    t.integer  "site_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "antennas", :force => true do |t|
    t.string   "band"
    t.string   "vendor"
    t.string   "code"
    t.decimal  "hba"
    t.decimal  "azimuth"
    t.decimal  "mechanical_tilt"
    t.decimal  "electrical_tilt_900"
    t.decimal  "electrical_tilt_1800"
    t.decimal  "electrical_tilt_2100"
    t.string   "design_status"
    t.integer  "sector_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "assignments", :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "audits", :force => true do |t|
    t.datetime "date"
    t.integer  "user_id"
    t.string   "rigger"
    t.string   "status"
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "complaints", :force => true do |t|
    t.string   "incident"
    t.string   "problem_status"
    t.datetime "escalation_time"
    t.string   "msisdn"
    t.string   "party_a"
    t.string   "alternate_number"
    t.string   "ne_name"
    t.string   "cell_id"
    t.string   "brief_description"
    t.string   "revenue_band"
    t.string   "package_type"
    t.string   "duration"
    t.string   "noc_status"
    t.string   "assigned_to"
    t.string   "dt_conducted_by"
    t.string   "orf_sent_to"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "partners", :force => true do |t|
    t.string   "status"
    t.string   "operator"
    t.string   "code"
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "proposals", :force => true do |t|
    t.decimal  "hba"
    t.decimal  "azimuth"
    t.decimal  "mechanical_tilt"
    t.decimal  "electrical_tilt_900"
    t.decimal  "electrical_tilt_1800"
    t.decimal  "electrical_tilt_2100"
    t.string   "design_status"
    t.integer  "antenna_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "proposed_by"
    t.datetime "proposed_at"
    t.integer  "committed_by"
    t.datetime "committed_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sectors", :force => true do |t|
    t.string   "code"
    t.integer  "cell"
    t.string   "serving_area"
    t.string   "morphology"
    t.string   "bracket_type"
    t.string   "feeder_type"
    t.decimal  "feeder_length"
    t.string   "blocking"
    t.integer  "site_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "sites", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "equipment_vendor"
    t.string   "equipment_type"
    t.string   "type"
    t.string   "coverage_type"
    t.string   "cabinet_type"
    t.string   "structure_type"
    t.decimal  "structure_height"
    t.decimal  "building_height"
    t.decimal  "amsl"
    t.string   "phase"
    t.datetime "on_air_date"
    t.string   "status"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "blocked"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
