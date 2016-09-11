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

ActiveRecord::Schema.define(version: 20160911071155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "club_admins", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "club_admins", ["club_id"], name: "index_club_admins_on_club_id", using: :btree
  add_index "club_admins", ["user_id"], name: "index_club_admins_on_user_id", using: :btree

  create_table "clubs", force: :cascade do |t|
    t.text     "name"
    t.text     "city"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "surname"
    t.date     "birthday"
    t.integer  "rank"
    t.integer  "sex"
    t.integer  "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "players", ["club_id"], name: "index_players_on_club_id", using: :btree

  create_table "team_memberships", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "team_memberships", ["player_id"], name: "index_team_memberships_on_player_id", using: :btree
  add_index "team_memberships", ["team_id"], name: "index_team_memberships_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "teams", ["tournament_id"], name: "index_teams_on_tournament_id", using: :btree

  create_table "tournament_admins", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tournament_id"
    t.integer  "status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tournament_admins", ["tournament_id"], name: "index_tournament_admins_on_tournament_id", using: :btree
  add_index "tournament_admins", ["user_id"], name: "index_tournament_admins_on_user_id", using: :btree

  create_table "tournament_participations", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tournament_participations", ["player_id"], name: "index_tournament_participations_on_player_id", using: :btree
  add_index "tournament_participations", ["tournament_id"], name: "index_tournament_participations_on_tournament_id", using: :btree

  create_table "tournaments", force: :cascade do |t|
    t.integer  "state"
    t.string   "name"
    t.integer  "playoff_match_length"
    t.integer  "group_match_length"
    t.integer  "team_size"
    t.integer  "player_age_constraint"
    t.integer  "player_age_constraint_value"
    t.integer  "player_sex_constraint"
    t.integer  "player_sex_constraint_value"
    t.integer  "player_rank_constraint"
    t.integer  "player_rank_constraint_value"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "club_admins", "clubs"
  add_foreign_key "club_admins", "users"
  add_foreign_key "players", "clubs"
  add_foreign_key "team_memberships", "players"
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "teams", "tournaments"
  add_foreign_key "tournament_admins", "tournaments"
  add_foreign_key "tournament_admins", "users"
  add_foreign_key "tournament_participations", "players"
  add_foreign_key "tournament_participations", "tournaments"
end
