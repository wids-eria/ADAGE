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

ActiveRecord::Schema.define(:version => 20140509211600) do

  create_table "access_tokens", :force => true do |t|
    t.string   "consumer_token"
    t.string   "consumer_secret"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
    t.integer  "client_id"
  end

  add_index "access_tokens", ["client_id"], :name => "fk__access_tokens_client_id"
  add_index "access_tokens", ["user_id"], :name => "fk__access_tokens_user_id"

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "disabled_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "assigner_id"
  end

  add_index "assignments", ["assigner_id"], :name => "fk__assignments_assigner_id"
  add_index "assignments", ["role_id"], :name => "fk__assignments_role_id"
  add_index "assignments", ["user_id"], :name => "fk__assignments_user_id"

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "app_token"
    t.string   "app_secret"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "implementation_id"
  end

  add_index "clients", ["implementation_id"], :name => "fk__clients_implementation_id"

  create_table "games", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groupownerships", :force => true do |t|
    t.integer "groupownerships_id"
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "playsquad",  :default => true
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "groups_users", ["group_id"], :name => "fk__groups_users_group_id"
  add_index "groups_users", ["user_id"], :name => "fk__groups_users_user_id"

  create_table "implementations", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "implementations", ["game_id"], :name => "fk__implementations_game_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
    t.integer  "game_id"
  end

  add_index "roles", ["game_id"], :name => "fk__roles_game_id"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "fk__roles_users_role_id"
  add_index "roles_users", ["user_id"], :name => "fk__roles_users_user_id"

  create_table "social_access_tokens", :force => true do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "access_token"
    t.datetime "expired_at"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "social_access_tokens", ["user_id"], :name => "fk__social_access_tokens_user_id"
  add_index "social_access_tokens", ["user_id"], :name => "index_social_access_tokens_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "authentication_token"
    t.boolean  "consented",                             :default => false
    t.boolean  "control_group"
    t.string   "player_name",                           :default => ""
    t.boolean  "guest",                                 :default => false
    t.integer  "teacher_status_cd"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
