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

ActiveRecord::Schema.define(version: 20140406171755) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "age_brackets", force: true do |t|
    t.integer  "policy_id"
    t.integer  "min_age"
    t.integer  "max_age"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "age_brackets", ["policy_id"], name: "index_age_brackets_on_policy_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "short_hand"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coverage_categories", force: true do |t|
    t.integer  "policy_id"
    t.string   "name"
    t.string   "description"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coverage_categories", ["policy_id"], name: "index_coverage_categories_on_policy_id", using: :btree

  create_table "coverages", force: true do |t|
    t.integer  "policy_id"
    t.integer  "category_id"
    t.string   "name"
    t.string   "description"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coverages", ["category_id"], name: "index_coverages_on_category_id", using: :btree
  add_index "coverages", ["policy_id"], name: "index_coverages_on_policy_id", using: :btree

  create_table "deductibles", force: true do |t|
    t.integer  "policy_id"
    t.integer  "amount"
    t.integer  "mutiplier"
    t.integer  "age"
    t.string   "condition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deductibles", ["policy_id"], name: "index_deductibles_on_policy_id", using: :btree

  create_table "destinations", force: true do |t|
    t.integer  "policy_id"
    t.string   "place"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "destinations", ["policy_id"], name: "index_destinations_on_policy_id", using: :btree

  create_table "policies", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "short_hand"
    t.string   "policy_number"
    t.datetime "eff_date"
    t.string   "rate_type"
    t.string   "describition"
    t.string   "purchase_url"
    t.boolean  "can_buy_after_30_days"
    t.string   "status"
    t.integer  "min_age"
    t.integer  "max_age"
    t.integer  "max_age_with_kids"
    t.integer  "max_age_kids"
    t.integer  "min_trip_duration"
    t.integer  "max_trip_duration"
    t.integer  "min_adult"
    t.integer  "max_adult"
    t.integer  "min_dependant"
    t.integer  "max_dependant"
    t.integer  "min_price"
    t.boolean  "preex"
    t.integer  "preex_max_age"
    t.boolean  "super_visa_partial_refund"
    t.boolean  "right_of_entry"
    t.boolean  "renewable"
    t.integer  "renewable_period"
    t.integer  "renewable_max_age"
    t.boolean  "follow_ups"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "policies", ["company_id"], name: "index_policies_on_company_id", using: :btree

  create_table "provinces", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "short_hand"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provinces", ["company_id"], name: "index_provinces_on_company_id", using: :btree

  create_table "rates", force: true do |t|
    t.integer  "age_bracket_id"
    t.integer  "rate"
    t.integer  "eff_dat"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["age_bracket_id"], name: "index_rates_on_age_bracket_id", using: :btree

  create_table "refundable_texts", force: true do |t|
    t.integer  "policy_id"
    t.string   "describition"
    t.string   "policy_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refundable_texts", ["policy_id"], name: "index_refundable_texts_on_policy_id", using: :btree

  create_table "sum_insureds", force: true do |t|
    t.integer  "age_bracket_id"
    t.integer  "max_age"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sum_insureds", ["age_bracket_id"], name: "index_sum_insureds_on_age_bracket_id", using: :btree

  create_table "trip_values", force: true do |t|
    t.integer  "policy_id"
    t.integer  "min_value"
    t.integer  "max_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trip_values", ["policy_id"], name: "index_trip_values_on_policy_id", using: :btree

end
