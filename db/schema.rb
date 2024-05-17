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

ActiveRecord::Schema[7.1].define(version: 2024_05_16_185905) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "buffets", force: :cascade do |t|
    t.string "trading_name"
    t.string "company_name"
    t.string "registration_number"
    t.string "contact_number"
    t.string "email"
    t.string "address"
    t.string "district"
    t.string "state"
    t.string "city"
    t.string "zipcode"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "payment_methods"
    t.boolean "is_enabled", default: true
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_buffets_on_user_id"
  end

  create_table "chat_messages", force: :cascade do |t|
    t.string "text"
    t.integer "status", default: 0
    t.integer "sender_id", null: false
    t.integer "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_chat_messages_on_order_id"
    t.index ["sender_id"], name: "index_chat_messages_on_sender_id"
  end

  create_table "event_prices", force: :cascade do |t|
    t.integer "base_price"
    t.integer "additional_person_price"
    t.integer "additional_hour_price"
    t.integer "weekend_base_price"
    t.integer "weekend_additional_person_price"
    t.integer "weekend_additional_hour_price"
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_prices_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "minimum_participants"
    t.integer "maximum_participants"
    t.integer "default_duration"
    t.string "menu"
    t.boolean "alcoholic_drinks"
    t.boolean "decorations"
    t.boolean "valet_service"
    t.integer "buffet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "can_change_location"
    t.boolean "is_enabled", default: true
    t.datetime "deleted_at"
    t.index ["buffet_id"], name: "index_events_on_buffet_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "code"
    t.date "desired_date"
    t.integer "estimated_invitees"
    t.string "observation"
    t.integer "status", default: 0
    t.string "desired_address"
    t.integer "buffet_id", null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["buffet_id"], name: "index_orders_on_buffet_id"
    t.index ["event_id"], name: "index_orders_on_event_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "proposals", force: :cascade do |t|
    t.integer "total_value"
    t.date "expire_date"
    t.string "description"
    t.integer "discount"
    t.integer "tax"
    t.integer "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method"
    t.index ["order_id"], name: "index_proposals_on_order_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating", default: 0, null: false
    t.string "comment"
    t.integer "order_id", null: false
    t.integer "reviewer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_reviews_on_order_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.string "full_name"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "social_security_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "buffets", "users"
  add_foreign_key "chat_messages", "orders"
  add_foreign_key "chat_messages", "users", column: "sender_id"
  add_foreign_key "event_prices", "events"
  add_foreign_key "events", "buffets"
  add_foreign_key "orders", "buffets"
  add_foreign_key "orders", "events"
  add_foreign_key "orders", "users"
  add_foreign_key "proposals", "orders"
  add_foreign_key "reviews", "orders"
  add_foreign_key "reviews", "users", column: "reviewer_id"
end
