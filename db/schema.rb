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

ActiveRecord::Schema[7.2].define(version: 2024_09_17_095357) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mutations", force: :cascade do |t|
    t.bigint "wallet_id", null: false
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "related_mutation_id"
    t.index ["related_mutation_id"], name: "index_mutations_on_related_mutation_id"
    t.index ["wallet_id"], name: "index_mutations_on_wallet_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id", null: false
    t.datetime "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.bigint "src_wallet_id", null: false
    t.bigint "dest_wallet_id", null: false
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dest_wallet_id"], name: "index_transfers_on_dest_wallet_id"
    t.index ["src_wallet_id"], name: "index_transfers_on_src_wallet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "mutations", "mutations", column: "related_mutation_id"
  add_foreign_key "mutations", "wallets"
  add_foreign_key "sessions", "users"
  add_foreign_key "transfers", "wallets", column: "dest_wallet_id"
  add_foreign_key "transfers", "wallets", column: "src_wallet_id"
  add_foreign_key "wallets", "users"
end
