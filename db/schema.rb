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

ActiveRecord::Schema.define(version: 20171111205647) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.integer  "recipient_id",               null: false
    t.string   "recipient_type",             null: false
    t.string   "type",                       null: false
    t.integer  "points",         default: 0
    t.datetime "created_at"
  end

  create_table "attendances", force: :cascade do |t|
    t.integer  "registration_id"
    t.integer  "mission_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bonus_codes", force: :cascade do |t|
    t.string   "code"
    t.integer  "points"
    t.integer  "game_id"
    t.integer  "registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "check_ins", force: :cascade do |t|
    t.integer  "registration_id"
    t.string   "hostname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string   "from"
    t.string   "regarding"
    t.text     "body"
    t.datetime "occurred"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.boolean  "visible",    default: true
    t.text     "note"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.integer  "registration_id"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
    t.integer  "mission_id"
  end

  create_table "games", force: :cascade do |t|
    t.string   "short_name"
    t.datetime "registration_begins"
    t.datetime "registration_ends"
    t.datetime "game_begins"
    t.datetime "game_ends"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_current"
    t.text     "information",         default: "No information given."
    t.text     "rules",               default: "No rules have been posted yet. Check back later!"
    t.string   "time_zone",           default: "Eastern Time (US & Canada)"
    t.datetime "oz_reveal"
  end

  create_table "human_reports", force: :cascade do |t|
    t.integer  "game_id_id"
    t.string   "location_lat"
    t.string   "location_long"
    t.integer  "num_humans"
    t.integer  "typical_mag_size"
    t.datetime "time_sighted"
  end

  create_table "infractions", force: :cascade do |t|
    t.integer  "registration_id"
    t.text     "reason"
    t.integer  "admin_id"
    t.integer  "severity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "nullified",       default: false
  end

  create_table "missions", force: :cascade do |t|
    t.integer  "game_id"
    t.datetime "start"
    t.datetime "end"
    t.text     "description"
    t.integer  "winning_faction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "storyline"
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "caseid"
    t.binary   "picture"
    t.string   "phone"
    t.datetime "last_login"
    t.boolean  "is_admin",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_of_birth"
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "game_id"
    t.integer  "faction_id"
    t.string   "card_code"
    t.integer  "score"
    t.boolean  "is_oz",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "wants_oz",      default: false
    t.boolean  "is_off_campus", default: false
    t.integer  "squad_id"
    t.string   "human_type"
  end

  create_table "squads", force: :cascade do |t|
    t.string   "name"
    t.integer  "leader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
  end

  create_table "tags", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "tagger_id"
    t.integer  "tagee_id"
    t.datetime "datetime"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_id"
    t.decimal  "latitude"
    t.decimal  "longitude"
  end

  create_table "waivers", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "game_id"
    t.integer  "studentid"
    t.date     "datesigned"
    t.string   "emergencyname"
    t.string   "emergencyrelationship"
    t.string   "emergencyphone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zombie_reports", force: :cascade do |t|
    t.integer  "game_id_id"
    t.string   "location_lat"
    t.string   "location_long"
    t.integer  "num_zombies"
    t.datetime "time_sighted"
  end

end
