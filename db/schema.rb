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

ActiveRecord::Schema.define(version: 2018_05_29_232850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commutes", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "address"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "locatable_type"
    t.bigint "locatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locatable_type", "locatable_id"], name: "index_locations_on_locatable_type_and_locatable_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.bigint "commute_id"
    t.datetime "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commute_id"], name: "index_reminders_on_commute_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "schedulable_type"
    t.bigint "schedulable_id"
    t.date "date"
    t.time "time"
    t.string "rule"
    t.string "interval"
    t.text "day"
    t.text "day_of_week"
    t.datetime "until"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedulable_type", "schedulable_id"], name: "index_schedules_on_schedulable_type_and_schedulable_id"
  end

end