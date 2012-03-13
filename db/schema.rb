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

ActiveRecord::Schema.define(:version => 24) do

  create_table "identities", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "identities", ["user_id"], :name => "index_identities_on_user_id"

  create_table "locators", :force => true do |t|
    t.string   "scheme"
    t.string   "userinfo"
    t.integer  "port"
    t.string   "registry"
    t.string   "path"
    t.string   "opaque"
    t.string   "query"
    t.string   "fragment"
    t.string   "url"
    t.integer  "site_id"
    t.integer  "tips_count", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "page_id"
  end

  add_index "locators", ["site_id", "page_id"], :name => "index_locators_on_site_id_and_page_id"

  create_table "pages", :force => true do |t|
    t.string   "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "pages_royalty_orders", :id => false, :force => true do |t|
    t.integer "page_id"
    t.integer "royalty_order_id"
  end

  add_index "pages_royalty_orders", ["page_id", "royalty_order_id"], :name => "index_pages_royalty_orders_on_page_id_and_royalty_order_id"

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

  create_table "royalty_orders", :force => true do |t|
    t.integer  "cycle_started_year",    :null => false
    t.integer  "cycle_started_quarter", :null => false
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "sites", :force => true do |t|
    t.string   "fqdn",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sites", ["fqdn"], :name => "index_sites_on_fqdn", :unique => true

  create_table "tip_orders", :force => true do |t|
    t.boolean  "is_active",    :default => true
    t.integer  "fan_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "charge_token"
  end

  add_index "tip_orders", ["fan_id"], :name => "index_tip_orders_on_fan_id"

  create_table "tip_royalties", :force => true do |t|
    t.integer  "royalty_order_id", :null => false
    t.integer  "tip_id",           :null => false
    t.integer  "amount_in_cents",  :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "tip_royalties", ["royalty_order_id", "tip_id"], :name => "index_tip_royalties_on_royalty_order_id_and_tip_id"

  create_table "tips", :force => true do |t|
    t.integer  "amount_in_cents"
    t.integer  "tip_order_id",    :null => false
    t.integer  "locator_id",      :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "tips", ["tip_order_id", "locator_id"], :name => "index_tips_on_tip_order_id_and_locator_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "tip_preference_in_cents", :default => 50,    :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "email"
    t.string   "stripe_customer_id"
    t.boolean  "accept_terms",            :default => false
    t.boolean  "automatic_rebill",        :default => false
  end

end
