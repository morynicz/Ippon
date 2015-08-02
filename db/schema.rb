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

ActiveRecord::Schema.define(version: 20150802160338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fight_states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fights", force: :cascade do |t|
    t.integer  "aka_points"
    t.integer  "shiro_points"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "final_fights", force: :cascade do |t|
    t.integer  "previous_aka_fight_id"
    t.integer  "previous_shiro_fight_id"
    t.integer  "fight_id"
    t.integer  "tournament_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "final_fights", ["previous_aka_fight_id"], name: "index_final_fights_on_previous_aka_fight_id", using: :btree
  add_index "final_fights", ["previous_shiro_fight_id"], name: "index_final_fights_on_previous_shiro_fight_id", using: :btree

  create_table "group_fights", force: :cascade do |t|
    t.integer  "fight_id"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "group_memebers", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "group_memebers", ["group_id"], name: "index_group_memebers_on_group_id", using: :btree
  add_index "group_memebers", ["player_id"], name: "index_group_memebers_on_player_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "fight_id"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "participations", ["player_id"], name: "index_participations_on_player_id", using: :btree
  add_index "participations", ["tournament_id"], name: "index_participations_on_tournament_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "club"
    t.integer  "rank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ranks", force: :cascade do |t|
    t.string   "name"
    t.boolean  "is_dan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.string   "place"
    t.integer  "final_fight_len"
    t.integer  "group_fight_len"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "group_memebers", "groups"
  add_foreign_key "group_memebers", "players"
  add_foreign_key "participations", "players"
  add_foreign_key "participations", "tournaments"
end
