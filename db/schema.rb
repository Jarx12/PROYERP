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

ActiveRecord::Schema[8.1].define(version: 2026_10_04_120000) do
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

  create_table "bank_accounts", force: :cascade do |t|
    t.string "institution"
    t.string "currency"
    t.string "account_number"
    t.string "email"
    t.decimal "balance", precision: 12, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.integer "category"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employee_id"
    t.index ["employee_id"], name: "index_documents_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "name2"
    t.string "surname2"
    t.integer "cedula"
    t.string "direccion"
    t.string "telefono"
    t.date "birthday"
    t.date "hire_date"
    t.decimal "salary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position_id"
    t.datetime "discarded_at"
    t.index ["cedula"], name: "index_employees_on_cedula", unique: true
    t.index ["discarded_at"], name: "index_employees_on_discarded_at"
    t.index ["position_id"], name: "index_employees_on_position_id"
  end

  create_table "financial_transactions", force: :cascade do |t|
    t.integer "bank_account_id", null: false
    t.integer "transaction_category_id"
    t.integer "employee_id"
    t.decimal "amount", precision: 12, scale: 2, default: "0.0"
    t.string "transaction_type"
    t.text "description"
    t.string "responsible_name"
    t.string "beneficiary"
    t.date "transaction_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bank_reference"
    t.index ["bank_account_id"], name: "index_financial_transactions_on_bank_account_id"
    t.index ["employee_id"], name: "index_financial_transactions_on_employee_id"
    t.index ["transaction_category_id"], name: "index_financial_transactions_on_transaction_category_id"
    t.index ["transaction_date"], name: "index_financial_transactions_on_transaction_date"
  end

  create_table "permissions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "module_key", null: false
    t.boolean "can_read", default: false, null: false
    t.boolean "can_write", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "module_key"], name: "index_permissions_on_user_id_and_module_key", unique: true
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.integer "stock_current"
    t.integer "stock_minimum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "category_id"
    t.integer "warehouse_id"
    t.string "location_detail"
    t.decimal "price_cost", precision: 10, scale: 2, default: "0.0"
    t.decimal "price_sale", precision: 10, scale: 2, default: "0.0"
    t.decimal "weight", precision: 8, scale: 3
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["warehouse_id"], name: "index_products_on_warehouse_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.string "location"
    t.string "customer"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_movements", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "quantity"
    t.integer "movement_type"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_stock_movements_on_product_id"
  end

  create_table "transaction_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "superuser", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_id"], name: "index_users_on_employee_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vehicle_assignments", force: :cascade do |t|
    t.integer "vehicle_id", null: false
    t.integer "employee_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_vehicle_assignments_on_employee_id"
    t.index ["vehicle_id"], name: "index_vehicle_assignments_on_vehicle_id"
  end

  create_table "vehicle_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "plate"
    t.string "brand"
    t.string "model"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "engine_serial"
    t.string "body_serial"
    t.string "color"
    t.integer "seats"
    t.integer "year"
    t.decimal "load_capacity", precision: 10, scale: 2
    t.string "owner_dni"
    t.integer "condition"
    t.string "policy_number"
    t.date "policy_expiration"
    t.integer "vehicle_category_id", null: false
    t.index ["vehicle_category_id"], name: "index_vehicles_on_vehicle_category_id"
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "documents", "employees"
  add_foreign_key "employees", "positions"
  add_foreign_key "financial_transactions", "bank_accounts"
  add_foreign_key "financial_transactions", "employees"
  add_foreign_key "financial_transactions", "transaction_categories"
  add_foreign_key "permissions", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "warehouses"
  add_foreign_key "stock_movements", "products"
  add_foreign_key "users", "employees"
  add_foreign_key "vehicle_assignments", "employees"
  add_foreign_key "vehicle_assignments", "vehicles"
  add_foreign_key "vehicles", "vehicle_categories"
end
