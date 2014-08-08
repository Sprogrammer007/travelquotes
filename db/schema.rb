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

ActiveRecord::Schema.define(version: 20140807190954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.integer  "product_id"
    t.integer  "min_age"
    t.integer  "max_age"
    t.integer  "min_trip_duration"
    t.integer  "max_trip_duration"
    t.boolean  "preex"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "age_sets", id: false, force: true do |t|
    t.integer "age_bracket_id"
    t.integer "version_id"
  end

  add_index "age_sets", ["age_bracket_id"], name: "index_age_sets_on_age_bracket_id", using: :btree
  add_index "age_sets", ["version_id"], name: "index_age_sets_on_version_id", using: :btree

  create_table "all_inclusive_rates", force: true do |t|
    t.integer  "age_bracket_id"
    t.float    "rate"
    t.string   "rate_type"
    t.integer  "min_date"
    t.integer  "max_date"
    t.integer  "rate_trip_value"
    t.integer  "sum_insured"
    t.datetime "effective_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "all_inclusive_rates", ["age_bracket_id"], name: "index_all_inclusive_rates_on_age_bracket_id", using: :btree

  create_table "applied_filters", id: false, force: true do |t|
    t.integer "quote_id"
    t.integer "product_filter_id"
  end

  add_index "applied_filters", ["product_filter_id"], name: "index_applied_filters_on_product_filter_id", using: :btree
  add_index "applied_filters", ["quote_id"], name: "index_applied_filters_on_quote_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.boolean  "status",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "couple_details", force: true do |t|
    t.integer "min_age"
    t.integer "max_age"
    t.boolean "has_couple_rate"
  end

  create_table "deductibles", force: true do |t|
    t.integer  "product_id"
    t.integer  "amount"
    t.float    "mutiplier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "min_age"
    t.integer  "max_age"
  end

  create_table "family_details", force: true do |t|
    t.integer "min_age"
    t.integer "max_age"
    t.integer "min_dependant"
    t.integer "max_dependant"
    t.integer "min_adult"
    t.integer "max_adult"
    t.integer "max_kids_age"
    t.integer "max_age_with_kids"
    t.string  "family_rate_type"
  end

  create_table "legal_text_categories", force: true do |t|
    t.integer  "legal_text_parent_category_id"
    t.string   "name"
    t.integer  "order"
    t.text     "popup_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legal_text_parent_categories", force: true do |t|
    t.string   "name"
    t.integer  "order"
    t.text     "popup_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legal_texts", force: true do |t|
    t.integer  "product_id"
    t.integer  "legal_text_category_id"
    t.string   "policy_type"
    t.text     "description"
    t.boolean  "status",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_filter_sets", id: false, force: true do |t|
    t.integer "product_filter_id"
    t.integer "product_id"
  end

  add_index "product_filter_sets", ["product_filter_id"], name: "index_product_filter_sets_on_product_filter_id", using: :btree
  add_index "product_filter_sets", ["product_id"], name: "index_product_filter_sets_on_product_id", using: :btree

  create_table "product_filters", force: true do |t|
    t.string  "category"
    t.string  "name"
    t.string  "policy_type"
    t.text    "descriptions"
    t.integer "associated_lt_id"
  end

  create_table "products", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "policy_number"
    t.text     "description"
    t.integer  "min_price"
    t.boolean  "can_buy_after_30_days"
    t.boolean  "can_renew_after_30_days"
    t.integer  "renewable_max_age"
    t.boolean  "preex"
    t.integer  "preex_max_age"
    t.boolean  "preex_based_on_sum_insured", default: false
    t.boolean  "status",                     default: true
    t.string   "purchase_url",               default: "http://"
    t.datetime "rate_effective_date"
    t.datetime "future_rate_effective_date"
    t.datetime "effective_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "policy_type"
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
  end

  add_index "products", ["company_id"], name: "index_products_on_company_id", using: :btree

  create_table "provinces", force: true do |t|
    t.string "name"
    t.string "flag"
    t.string "short_hand"
    t.string "country"
  end

  create_table "quotes", force: true do |t|
    t.string   "quote_id"
    t.string   "client_ip"
    t.string   "quote_type"
    t.string   "email"
    t.boolean  "renew"
    t.datetime "renew_expire_date"
    t.datetime "leave_home"
    t.datetime "return_home"
    t.boolean  "apply_from"
    t.string   "deductible_filter"
    t.boolean  "has_preex"
    t.datetime "arrival_date"
    t.integer  "trip_cost"
    t.integer  "sum_insured"
    t.string   "traveler_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "quote_sub_type"
  end

  create_table "rates", force: true do |t|
    t.integer  "age_bracket_id"
    t.float    "rate"
    t.string   "rate_type"
    t.integer  "sum_insured"
    t.datetime "effective_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["age_bracket_id"], name: "index_rates_on_age_bracket_id", using: :btree

  create_table "regions", id: false, force: true do |t|
    t.integer "province_id"
    t.integer "company_id"
  end

  add_index "regions", ["company_id"], name: "index_regions_on_company_id", using: :btree
  add_index "regions", ["province_id"], name: "index_regions_on_province_id", using: :btree

  create_table "single_details", force: true do |t|
    t.integer "min_age"
    t.integer "max_age"
  end

  create_table "student_age_brackets", force: true do |t|
    t.integer  "student_product_id"
    t.integer  "min_age"
    t.integer  "max_age"
    t.integer  "min_trip_duration"
    t.integer  "max_trip_duration"
    t.boolean  "preex"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_couple_details", force: true do |t|
    t.integer "min_age"
    t.integer "max_age"
    t.boolean "has_couple_rate"
  end

  create_table "student_family_details", force: true do |t|
    t.integer "min_age"
    t.integer "max_age"
    t.integer "min_dependant"
    t.integer "max_dependant"
    t.integer "min_adult"
    t.integer "max_adult"
    t.integer "max_kids_age"
    t.integer "max_age_with_kids"
    t.boolean "has_family_rate"
  end

  create_table "student_filter_sets", id: false, force: true do |t|
    t.integer "student_filter_id"
    t.integer "student_product_id"
  end

  add_index "student_filter_sets", ["student_filter_id"], name: "index_student_filter_sets_on_student_filter_id", using: :btree
  add_index "student_filter_sets", ["student_product_id"], name: "index_student_filter_sets_on_student_product_id", using: :btree

  create_table "student_filters", force: true do |t|
    t.string "category"
    t.string "name"
    t.text   "descriptions"
  end

  create_table "student_legal_texts", force: true do |t|
    t.integer  "studentproduct_id"
    t.integer  "student_lg_cat_id"
    t.text     "description"
    t.datetime "effective_date"
    t.boolean  "status",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_lg_cats", force: true do |t|
    t.integer "student_lg_parent_cat_id"
    t.string  "name"
    t.integer "order"
    t.text    "popup_description"
  end

  create_table "student_lg_parent_cats", force: true do |t|
    t.string  "name"
    t.integer "order"
    t.text    "popup_description"
  end

  create_table "student_products", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "policy_number"
    t.text     "description"
    t.integer  "min_price"
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.boolean  "can_buy_after_30_days"
    t.boolean  "can_renew_after_30_days"
    t.integer  "renewable_max_age"
    t.boolean  "preex"
    t.integer  "preex_max_age"
    t.boolean  "preex_based_on_sum_insured", default: false
    t.boolean  "status",                     default: true
    t.string   "purchase_url",               default: "http://"
    t.datetime "rate_effective_date"
    t.datetime "future_rate_effective_date"
    t.datetime "effective_date"
  end

  add_index "student_products", ["company_id"], name: "index_student_products_on_company_id", using: :btree

  create_table "student_rates", force: true do |t|
    t.integer  "student_age_bracket_id"
    t.float    "rate"
    t.string   "rate_type"
    t.integer  "sum_insured"
    t.datetime "effective_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_rates", ["student_age_bracket_id"], name: "index_student_rates_on_student_age_bracket_id", using: :btree

  create_table "student_single_details", force: true do |t|
    t.integer "min_age"
    t.integer "max_age"
  end

  create_table "student_versions", force: true do |t|
    t.integer  "student_product_id"
    t.string   "detail_type"
    t.integer  "detail_id"
    t.boolean  "status",             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_versions", ["student_product_id"], name: "index_student_versions_on_student_product_id", using: :btree

  create_table "traveler_members", force: true do |t|
    t.integer  "quote_id"
    t.datetime "birthday"
    t.string   "gender"
    t.string   "member_type"
  end

  create_table "trip_values", force: true do |t|
    t.integer  "plan_id"
    t.integer  "min_value"
    t.integer  "max_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: true do |t|
    t.integer  "product_id"
    t.string   "type"
    t.string   "detail_type"
    t.integer  "detail_id"
    t.boolean  "status",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["product_id"], name: "index_versions_on_product_id", using: :btree

end
