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

ActiveRecord::Schema.define(:version => 20100816010748) do

  create_table "achievements", :force => true do |t|
    t.integer  "user_id"
    t.string   "honor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "achievements", ["honor"], :name => "index_achievementings_on_achievement_id"
  add_index "achievements", ["user_id"], :name => "index_achievementings_on_user_id"

  create_table "contactings", :force => true do |t|
    t.integer  "host_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_share"
  end

  add_index "contactings", ["contact_id"], :name => "index_contacts_on_friend_id"
  add_index "contactings", ["host_id"], :name => "index_contacts_on_host_id"

  create_table "invitations", :force => true do |t|
    t.integer  "host_id"
    t.string   "contact_email"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["host_id"], :name => "index_invitations_on_host_id"

  create_table "online_records", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_records", ["key"], :name => "index_online_records_on_key"
  add_index "online_records", ["user_id"], :name => "index_online_records_on_user_id"

  create_table "preferences", :force => true do |t|
    t.integer  "user_id",                          :null => false
    t.boolean  "auto_popup_msg", :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_tooltip",   :default => true
    t.string   "theme"
  end

  add_index "preferences", ["user_id"], :name => "index_preferences_on_user_id"

  create_table "system_settings", :force => true do |t|
    t.string   "name"
    t.text     "footer_info"
    t.text     "login_info"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                      :default => "", :null => false
    t.string   "hashed_password",           :default => "", :null => false
    t.string   "salt",                      :default => "", :null => false
    t.string   "email",                     :default => "", :null => false
    t.string   "sign"
    t.string   "activation_code"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "activated_at"
    t.string   "reset_password_code"
    t.datetime "reset_password_code_until"
    t.datetime "last_login_time"
  end

end
