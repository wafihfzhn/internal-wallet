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

ActiveRecord::Schema[7.2].define(version: 2024_10_21_153102) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "transactions", force: :cascade do |t|
    t.bigint "source_id"
    t.bigint "target_id"
    t.string "transaction_type", null: false
    t.decimal "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_transactions_on_source_id"
    t.index ["target_id"], name: "index_transactions_on_target_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "full_name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "identifier", null: false
    t.decimal "balance", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_wallets_on_identifier", unique: true
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "transactions", "wallets", column: "source_id"
  add_foreign_key "transactions", "wallets", column: "target_id"
  add_foreign_key "wallets", "users"
end
