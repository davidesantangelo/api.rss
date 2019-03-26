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

ActiveRecord::Schema.define(version: 2019_03_26_082517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "feed_id"
    t.string "title"
    t.text "body"
    t.string "url"
    t.string "external_id"
    t.string "categories", array: true
    t.jsonb "annotations"
    t.jsonb "sentiment"
    t.datetime "published_at"
    t.datetime "enriched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["annotations"], name: "index_entries_on_annotations", using: :gin
    t.index ["categories"], name: "index_entries_on_categories", using: :gin
    t.index ["external_id"], name: "index_entries_on_external_id", unique: true
    t.index ["feed_id"], name: "index_entries_on_feed_id"
    t.index ["sentiment"], name: "index_entries_on_sentiment", using: :gin
    t.index ["url"], name: "index_entries_on_url", unique: true
  end

  create_table "feeds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.jsonb "image"
    t.string "url"
    t.string "tags", array: true
    t.float "rank", default: 0.0
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entries_count", default: 0
    t.index ["tags"], name: "index_feeds_on_tags", using: :gin
    t.index ["url"], name: "index_feeds_on_url", unique: true
  end

  create_table "tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key"
    t.datetime "expires_at"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_tokens_on_key", unique: true
  end

  add_foreign_key "entries", "feeds"
end
