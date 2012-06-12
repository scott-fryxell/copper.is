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

ActiveRecord::Schema.define(:version => 13) do

  create_table "auth_sources", :force => true do |t|
    t.string   "uid"
    t.string   "username"
    t.string   "name"
    t.string   "image"
    t.string   "location"
    t.string   "urls"
    t.string   "token"
    t.string   "secret"
    t.string   "type",              :null => false
    t.string   "auth_source_state"
    t.integer  "author_id"
    t.integer  "fan_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "auth_sources", ["type", "uid"], :name => "index_auth_sources_on_type_and_uid"
  add_index "auth_sources", ["type", "username"], :name => "index_auth_sources_on_type_and_username"

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "line1"
    t.string   "line2"
    t.string   "postal_code"
    t.string   "country"
    t.string   "state"
    t.string   "territory"
    t.string   "city"
    t.integer  "primary_channel_id"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "channels", :force => true do |t|
    t.integer  "author_id"
    t.string   "address"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "channels", ["author_id"], :name => "index_channels_on_author_id"

  create_table "checks", :force => true do |t|
    t.integer  "author_id"
    t.string   "check_state"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "checks", ["author_id"], :name => "index_checks_on_author_id"

  create_table "fans", :force => true do |t|
    t.string   "name"
    t.integer  "tip_preference_in_cents", :default => 25,    :null => false
    t.string   "stripe_customer_id"
    t.boolean  "accept_terms",            :default => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "fans", ["stripe_customer_id"], :name => "index_fans_on_stripe_customer_id"

  create_table "orders", :force => true do |t|
    t.integer  "fan_id"
    t.string   "order_state"
    t.string   "charge_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "url",          :null => false
    t.string   "author_state"
    t.integer  "author_id"
    t.integer  "site_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id", :unique => true

  create_table "sites", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tips", :force => true do |t|
    t.integer  "order_id",        :null => false
    t.integer  "check_id"
    t.integer  "page_id"
    t.integer  "amount_in_cents", :null => false
    t.string   "url",             :null => false
    t.string   "title"
    t.string   "paid_state"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "tips", ["check_id"], :name => "index_tips_on_check_id"
  add_index "tips", ["order_id"], :name => "index_tips_on_order_id"
  add_index "tips", ["page_id"], :name => "index_tips_on_page_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
