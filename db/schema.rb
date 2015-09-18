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

ActiveRecord::Schema.define(version: 20150912061601) do

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
    t.integer  "aka_id"
    t.integer  "shiro_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "location_id"
    t.integer  "fight_state_id"
  end

  add_index "fights", ["fight_state_id"], name: "index_fights_on_fight_state_id", using: :btree
  add_index "fights", ["location_id"], name: "index_fights_on_location_id", using: :btree

  create_table "final_fights", force: :cascade do |t|
    t.integer  "previous_aka_fight_id"
    t.integer  "previous_shiro_fight_id"
    t.integer  "fight_id"
    t.integer  "tournament_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "final_fights", ["fight_id"], name: "index_final_fights_on_fight_id", using: :btree
  add_index "final_fights", ["tournament_id"], name: "index_final_fights_on_tournament_id", using: :btree

  create_table "group_fights", force: :cascade do |t|
    t.integer  "fight_id"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "group_id"
  end

  add_index "group_fights", ["fight_id"], name: "index_group_fights_on_fight_id", using: :btree
  add_index "group_fights", ["group_id"], name: "index_group_fights_on_group_id", using: :btree
  add_index "group_fights", ["tournament_id"], name: "index_group_fights_on_tournament_id", using: :btree

  create_table "group_members", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "position"
  end

  add_index "group_members", ["group_id"], name: "index_group_members_on_group_id", using: :btree
  add_index "group_members", ["player_id"], name: "index_group_members_on_player_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "tournament_id"
    t.integer  "location_id"
  end

  add_index "groups", ["location_id"], name: "index_groups_on_location_id", using: :btree
  add_index "groups", ["tournament_id"], name: "index_groups_on_tournament_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "locations", ["tournament_id"], name: "index_locations_on_tournament_id", using: :btree

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
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "status",          default: 0, null: false
  end

  add_foreign_key "fights", "fight_states"
  add_foreign_key "fights", "locations"
  add_foreign_key "final_fights", "fights"
  add_foreign_key "final_fights", "tournaments"
  add_foreign_key "group_fights", "fights"
  add_foreign_key "group_fights", "groups"
  add_foreign_key "group_fights", "tournaments"
  add_foreign_key "group_members", "groups"
  add_foreign_key "group_members", "players"
  add_foreign_key "groups", "locations"
  add_foreign_key "groups", "tournaments"
  add_foreign_key "locations", "tournaments"
  add_foreign_key "participations", "players"
  add_foreign_key "participations", "tournaments"
end
