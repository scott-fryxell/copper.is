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

ActiveRecord::Schema.define(:version => 20100324194135) do

  create_table "accounts", :force => true do |t|
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "card_type"
    t.integer  "verification_value"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "card_expires_on"
    t.integer  "user_id"
    t.integer  "address_id"
  end

  create_table "addresses", :force => true do |t|
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "zip"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
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
    t.decimal  "amount"
    t.integer  "user_id"
    t.integer  "account_id"
  end

  create_table "resources", :force => true do |t|
    t.string   "scheme"
    t.string   "userinfo"
    t.string   "host"
    t.integer  "port"
    t.string   "registry"
    t.string   "path"
    t.string   "opaque"
    t.string   "query"
    t.string   "fragment"
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

  create_table "tips", :force => true do |t|
    t.text     "url"
    t.decimal  "amount"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
