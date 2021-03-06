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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150406204820) do

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "main",       limit: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "filter",     limit: 1
    t.integer  "group_id",   limit: 4
    t.boolean  "visible",    limit: 1
  end

  add_index "groups", ["group_id"], name: "index_groups_on_group_id", using: :btree

  create_table "groups_resources", force: :cascade do |t|
    t.integer  "group_id",    limit: 4,             null: false
    t.integer  "resource_id", limit: 4,             null: false
    t.integer  "rank",        limit: 4, default: 0, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "groups_resources", ["group_id", "resource_id"], name: "index_groups_resources_on_group_id_and_resource_id", using: :btree

  create_table "resources", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.string   "url",               limit: 255
    t.integer  "order",             limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "groups", "groups"
end
