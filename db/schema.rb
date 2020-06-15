# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_15_003653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "train_schedules", force: :cascade do |t|
    t.string "start_station_code"
    t.string "end_station_code"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "operator"
    t.string "operator_name"
    t.string "train_uid"
    t.string "service"
    t.string "service_timetable"
  end

  create_table "trip_stations", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.bigint "station_id", null: false
    t.string "function"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["station_id"], name: "index_trip_stations_on_station_id"
    t.index ["trip_id"], name: "index_trip_stations_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "trip_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "purpose"
    t.string "status", default: "upcoming"
    t.bigint "train_schedule_id"
    t.string "travel_direction"
    t.string "rating", default: "0"
    t.datetime "departs_at"
    t.datetime "arrives_at"
    t.index ["train_schedule_id"], name: "index_trips_on_train_schedule_id"
    t.index ["user_id"], name: "index_trips_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "trip_stations", "stations"
  add_foreign_key "trip_stations", "trips"
  add_foreign_key "trips", "train_schedules"
  add_foreign_key "trips", "users"
end
