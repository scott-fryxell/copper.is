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

ActiveRecord::Schema.define(:version => 8) do

  create_table "identities", :force => true do |t|
    t.string   "provider",   :null => false
    t.string   "uid"
    t.string   "username"
    t.string   "name"
    t.string   "email"
    t.string   "image"
    t.string   "location"
    t.string   "phone"
    t.string   "urls"
    t.string   "token"
    t.string   "secret"
    t.string   "type",       :null => false
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "url",          :null => false
    t.string   "author_state"
    t.integer  "identity_id"
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

  create_table "royalty_checks", :force => true do |t|
    t.integer  "user_id"
    t.string   "check_state"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tip_orders", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.string   "state"
    t.string   "charge_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tips", :force => true do |t|
    t.integer  "tip_order_id",     :null => false
    t.integer  "royalty_check_id"
    t.integer  "page_id",          :null => false
    t.integer  "amount_in_cents",  :null => false
    t.string   "paid_state"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "tip_preference_in_cents", :default => 50,    :null => false
    t.string   "email"
    t.string   "stripe_customer_id"
    t.boolean  "accept_terms",            :default => false
    t.boolean  "automatic_rebill",        :default => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

end
