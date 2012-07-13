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

ActiveRecord::Schema.define(:version => 10) do

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
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "channels", :force => true do |t|
    t.integer  "page_id"
    t.string   "uri"
    t.string   "site"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "channels", ["page_id"], :name => "index_channels_on_page_id"
  add_index "channels", ["site"], :name => "index_channels_on_site"

  create_table "fans", :force => true do |t|
    t.string   "name"
    t.integer  "tip_preference_in_cents", :default => 25, :null => false
    t.string   "stripe_id"
    t.integer  "author_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "fans", ["stripe_id"], :name => "index_fans_on_stripe_id"

  create_table "identities", :force => true do |t|
    t.string   "uid"
    t.string   "uri"
    t.string   "token"
    t.string   "secret"
    t.string   "type"
    t.string   "identity_state"
    t.integer  "author_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "identities", ["type", "uid"], :name => "index_identities_on_type_and_uid"

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.datetime "sent"
    t.string   "slug"
    t.integer  "channel_id"
    t.string   "redirect_to"
    t.datetime "checked"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "fan_id"
    t.string   "order_state"
    t.string   "charge_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "url",        :null => false
    t.string   "site"
    t.string   "path"
    t.string   "page_state"
    t.integer  "author_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pages", ["site"], :name => "index_pages_on_site"
  add_index "pages", ["url"], :name => "index_pages_on_url"

  create_table "roles", :force => true do |t|
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
    t.string   "tip_state"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "tips", ["check_id"], :name => "index_tips_on_check_id"
  add_index "tips", ["order_id"], :name => "index_tips_on_order_id"
  add_index "tips", ["page_id"], :name => "index_tips_on_page_id"

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
