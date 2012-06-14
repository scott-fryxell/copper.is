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

ActiveRecord::Schema.define(:version => 6) do

  create_table "auth_sources", :force => true do |t|
    t.string   "uid"
    t.string   "site"
    t.string   "user"
    t.string   "name"
    t.string   "image"
    t.string   "location"
    t.string   "urls"
    t.string   "token"
    t.string   "secret"
    t.string   "type"
    t.string   "auth_source_state"
    t.integer  "author_id"
    t.integer  "fan_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "auth_sources", ["type", "site"], :name => "index_auth_sources_on_type_and_site"
  add_index "auth_sources", ["type", "uid"], :name => "index_auth_sources_on_type_and_uid"
  add_index "auth_sources", ["type", "user"], :name => "index_auth_sources_on_type_and_user"

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
    t.integer  "page_id"
    t.string   "user"
    t.string   "site"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "channels", ["page_id"], :name => "index_channels_on_page_id"
  add_index "channels", ["site"], :name => "index_channels_on_site"

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
