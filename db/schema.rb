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

ActiveRecord::Schema.define(version: 20171111084053) do

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
    t.index ["slug"], name: "index_biographies_on_slug"
  end

  create_table "biography_authors", force: :cascade do |t|
    t.bigint "biography_id"
    t.bigint "author_id"
    t.integer "author_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_biography_authors_on_author_id"
    t.index ["biography_id"], name: "index_biography_authors_on_biography_id"
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
    t.index ["biography_id"], name: "index_images_on_biography_id"
  end

  create_table "static_contents", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

end
