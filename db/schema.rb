# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_16_110350) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "images", force: :cascade do |t|
    t.float "ave_value"
    t.datetime "created_at", null: false
    t.string "file"
    t.string "name"
    t.integer "theme_id"
    t.datetime "updated_at", null: false
  end

  create_table "themes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "qty_items"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "remember_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "values", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "image_id"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "value"
  end
end
