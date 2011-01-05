# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101209214804) do

  create_table "configurations", :force => true do |t|
    t.string   "property"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locators", :force => true do |t|
    t.string   "scheme"
    t.string   "userinfo"
    t.integer  "port"
    t.string   "registry"
    t.string   "path"
    t.string   "opaque"
    t.string   "query"
    t.string   "fragment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
    t.integer  "page_id"
    t.integer  "tips_count", :default => 0
  end

  create_table "pages", :force => true do |t|
    t.string   "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages_royalty_bundles", :id => false, :force => true do |t|
    t.integer "page_id"
    t.integer "royalty_bundle_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id", :unique => true

  create_table "royalty_bundles", :force => true do |t|
    t.integer  "cycle_started_year",    :null => false
    t.integer  "cycle_started_quarter", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "royalty_bundles_sites", :id => false, :force => true do |t|
    t.integer "royalty_bundle_id"
    t.integer "site_id"
  end

  create_table "rpx_identifiers", :force => true do |t|
    t.string   "identifier",    :null => false
    t.string   "provider_name"
    t.integer  "user_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rpx_identifiers", ["identifier"], :name => "index_rpx_identifiers_on_identifier", :unique => true
  add_index "rpx_identifiers", ["user_id"], :name => "index_rpx_identifiers_on_user_id"

  create_table "sites", :force => true do |t|
    t.string   "fqdn",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["fqdn"], :name => "index_sites_on_fqdn", :unique => true

  create_table "tip_bundles", :force => true do |t|
    t.boolean  "is_active",         :default => true
    t.integer  "fan_id"
    t.integer  "billing_period_id", :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tip_royalties", :force => true do |t|
    t.integer  "royalty_bundle_id", :null => false
    t.integer  "tip_id",            :null => false
    t.integer  "amount_in_cents",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tips", :force => true do |t|
    t.integer  "tip_bundle_id",   :null => false
    t.integer  "locator_id",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note"
    t.integer  "amount_in_cents"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "persistence_token"
    t.integer  "login_count",             :default => 1,  :null => false
    t.integer  "tip_preference_in_cents", :default => 50, :null => false
    t.integer  "failed_login_count",      :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
