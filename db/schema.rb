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

ActiveRecord::Schema.define(version: 20150220203747) do

  create_table "itunes_tracks", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "artist",           limit: 255
    t.string   "album",            limit: 255
    t.string   "genre",            limit: 255
    t.integer  "size",             limit: 4
    t.integer  "total_time",       limit: 4
    t.integer  "track_number",     limit: 4
    t.integer  "track_count",      limit: 4
    t.integer  "year",             limit: 4
    t.integer  "bit_rate",         limit: 4
    t.integer  "sample_rate",      limit: 4
    t.integer  "artwork_count",    limit: 4
    t.string   "persistent_id",    limit: 255
    t.text     "location",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_version",      limit: 4,     default: 0
    t.string   "publisher",        limit: 255
    t.string   "cover",            limit: 255
    t.integer  "rating",           limit: 4
    t.string   "artist_metaphone", limit: 255
    t.string   "name_metaphone",   limit: 255
    t.integer  "searched",         limit: 4,     default: 0
    t.date     "release_date"
    t.integer  "state",            limit: 4,     default: 0
  end

  add_index "itunes_tracks", ["album"], name: "index_itunes_tracks_on_album", using: :btree
  add_index "itunes_tracks", ["artist"], name: "index_itunes_tracks_on_artist", using: :btree
  add_index "itunes_tracks", ["genre"], name: "index_itunes_tracks_on_genre", using: :btree
  add_index "itunes_tracks", ["name"], name: "index_itunes_tracks_on_name", using: :btree
  add_index "itunes_tracks", ["persistent_id"], name: "index_itunes_tracks_on_persistent_id", using: :btree

  create_table "reference_album_covers", force: :cascade do |t|
    t.integer "reference_album_id", limit: 4
    t.string  "cover",              limit: 255
  end

  create_table "reference_albums", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.integer  "year",               limit: 4
    t.integer  "track_number",       limit: 4
    t.integer  "reference_label_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_id",        limit: 255
    t.integer  "external_type",      limit: 4
    t.date     "release_date"
  end

  add_index "reference_albums", ["external_id"], name: "index_reference_albums_on_external_id", using: :btree
  add_index "reference_albums", ["external_type"], name: "index_reference_albums_on_external_type", using: :btree
  add_index "reference_albums", ["name"], name: "index_reference_albums_on_name", using: :btree
  add_index "reference_albums", ["reference_label_id"], name: "index_reference_albums_on_reference_label_id", using: :btree

  create_table "reference_artists", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "name_metaphone", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_artists", ["name"], name: "index_reference_artists_on_name", using: :btree
  add_index "reference_artists", ["name_metaphone"], name: "index_reference_artists_on_name_metaphone", using: :btree

  create_table "reference_labels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_labels", ["name"], name: "index_reference_labels_on_name", using: :btree

  create_table "reference_track_artists", force: :cascade do |t|
    t.integer  "reference_track_id",  limit: 4
    t.integer  "reference_artist_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reference_tracks", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "name_metaphone",     limit: 255
    t.integer  "duration",           limit: 4
    t.integer  "track_position",     limit: 4
    t.integer  "reference_album_id", limit: 4
    t.text     "sample_url",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_id",        limit: 255
    t.integer  "external_type",      limit: 4
  end

  add_index "reference_tracks", ["name"], name: "index_reference_tracks_on_name", using: :btree
  add_index "reference_tracks", ["name_metaphone"], name: "index_reference_tracks_on_name_metaphone", using: :btree
  add_index "reference_tracks", ["reference_album_id"], name: "index_reference_tracks_on_reference_album_id", using: :btree

  create_table "wanted_tracks", force: :cascade do |t|
    t.string   "artist",             limit: 255
    t.string   "title",              limit: 255
    t.integer  "status",             limit: 4,   default: 0
    t.integer  "searched",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "found_in_myfreemp3", limit: 4
  end

end
