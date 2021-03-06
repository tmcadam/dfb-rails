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

ActiveRecord::Schema.define(version: 2021_05_13_020215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.text "biography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_name"
    t.string "first_name"
    t.index ["last_name", "first_name"], name: "index_authors_on_last_name_and_first_name", unique: true
  end

  create_table "biographies", force: :cascade do |t|
    t.string "title"
    t.string "lifespan"
    t.text "body"
    t.string "authors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.text "revisions"
    t.integer "primary_country_id"
    t.integer "secondary_country_id"
    t.boolean "south_georgia"
    t.boolean "featured"
    t.text "external_links"
    t.text "references"
    t.index ["slug"], name: "index_biographies_on_slug"
  end

  create_table "biography_authors", force: :cascade do |t|
    t.bigint "biography_id"
    t.bigint "author_id"
    t.integer "author_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_biography_authors_on_author_id"
    t.index ["biography_id", "author_id"], name: "index_biography_authors_on_biography_id_and_author_id", unique: true
    t.index ["biography_id", "author_position"], name: "index_biography_authors_on_biography_id_and_author_position", unique: true
    t.index ["biography_id"], name: "index_biography_authors_on_biography_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "biography_id"
    t.string "name"
    t.string "email"
    t.text "comment"
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "approve_key"
    t.index ["approve_key"], name: "index_comments_on_approve_key"
    t.index ["biography_id"], name: "index_comments_on_biography_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "images", force: :cascade do |t|
    t.string "title"
    t.text "caption"
    t.string "attribution"
    t.integer "biography_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "dim_x"
    t.integer "dim_y"
    t.index ["biography_id"], name: "index_images_on_biography_id"
  end

  create_table "static_contents", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "biographies", "countries", column: "primary_country_id"
  add_foreign_key "biographies", "countries", column: "secondary_country_id"
  add_foreign_key "comments", "biographies"
end
