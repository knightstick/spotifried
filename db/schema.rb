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

ActiveRecord::Schema.define(version: 2021_10_27_053134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "spotify_credentials", force: :cascade do |t|
    t.string "access_token", null: false
    t.string "refresh_token", null: false
    t.integer "expires_in", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_token"], name: "index_spotify_credentials_on_access_token"
    t.index ["refresh_token"], name: "index_spotify_credentials_on_refresh_token"
  end

  create_table "users", force: :cascade do |t|
    t.string "spotify_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["spotify_id"], name: "index_users_on_spotify_id", unique: true
  end

  create_table "users_spotify_credentials", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spotify_credential_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["spotify_credential_id"], name: "index_users_spotify_credentials_on_spotify_credential_id"
    t.index ["user_id"], name: "index_users_spotify_credentials_on_user_id"
  end

  add_foreign_key "users_spotify_credentials", "spotify_credentials"
  add_foreign_key "users_spotify_credentials", "users"
end
