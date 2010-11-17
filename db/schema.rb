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

ActiveRecord::Schema.define(:version => 20101116205804) do

  create_table "accounts", :force => true do |t|
    t.string   "number",             :limit => 16,   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verification_code"
    t.string   "billing_name",       :limit => 4096, :null => false
    t.date     "expires_on",                         :null => false
    t.integer  "user_id",                            :null => false
    t.integer  "billing_address_id",                 :null => false
    t.integer  "card_type_id",                       :null => false
  end

  create_table "addresses", :force => true do |t|
    t.string   "line_1",      :limit => nil,                   :null => false
    t.string   "line_2"
    t.string   "city",        :limit => nil,                   :null => false
    t.string   "postal_code", :limit => nil,                   :null => false
    t.string   "country",     :limit => nil, :default => "US", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",       :limit => 2,                     :null => false
    t.string   "territory",   :limit => nil
    t.string   "phone"
  end

  create_table "billing_periods", :force => true do |t|
  end

  create_table "card_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurations", :force => true do |t|
    t.string   "property"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
    t.string "abbreviation"
  end

  create_table "fees", :force => true do |t|
    t.integer  "transaction_id",  :null => false
    t.integer  "amount_in_cents"
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

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount_in_cents"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_address"
    t.integer  "amount_in_cents"
    t.integer  "account_id"
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

  create_table "refills", :force => true do |t|
    t.integer  "tip_bundle_id",   :null => false
    t.integer  "transaction_id",  :null => false
    t.integer  "amount_in_cents", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "sites", :force => true do |t|
    t.string   "fqdn",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["fqdn"], :name => "index_sites_on_fqdn", :unique => true

  create_table "states", :force => true do |t|
    t.string "name"
    t.string "abbreviation"
  end

  create_table "tip_bundles", :force => true do |t|
    t.boolean  "is_active",         :default => true
    t.integer  "fan_id"
    t.integer  "billing_period_id", :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tip_rates", :force => true do |t|
    t.integer "amount_in_cents"
  end

  create_table "tip_royalties", :force => true do |t|
    t.integer  "royalty_bundle_id", :null => false
    t.integer  "tip_id",            :null => false
    t.integer  "amount_in_cents",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tips", :force => true do |t|
    t.integer  "tip_bundle_id",                  :null => false
    t.integer  "locator_id",                     :null => false
    t.integer  "multiplier",      :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note"
    t.integer  "amount_in_cents"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "account_id",      :null => false
    t.integer  "amount_in_cents", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count",                       :default => 0,     :null => false
    t.integer  "failed_login_count",                :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token",                  :default => "",    :null => false
    t.boolean  "active",                            :default => false
    t.datetime "activation_date"
    t.string   "name"
    t.string   "new_email"
    t.string   "new_email_token"
    t.integer  "tip_rate_id"
    t.integer  "facebook_uid",         :limit => 8
    t.string   "facebook_session_key"
  end

end
