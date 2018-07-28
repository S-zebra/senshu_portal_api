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

ActiveRecord::Schema.define(version: 2018_07_27_143118) do

  create_table "accounts", force: :cascade do |t|
    t.string "student_id", null: false
    t.string "login_password", null: false
    t.string "generated_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lectures", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "day_of_week", null: false
    t.integer "slot", null: false
    t.string "lecture_name", null: false
    t.string "teacher_name", null: false
    t.string "classroom_name", null: false
    t.string "change_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_lectures_on_account_id"
  end

# Could not dump table "message_headers" because of following StandardError
#   Unknown type 'account_id' for column 'account_id'

  create_table "secures", force: :cascade do |t|
    t.string "enc_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_sessions_on_account_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "token", null: false
    t.boolean "available", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_tokens_on_account_id"
  end

end
