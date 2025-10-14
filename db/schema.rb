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

ActiveRecord::Schema[7.2].define(version: 2025_10_01_213309) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "api_keys", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "key", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_api_keys_on_key", unique: true
    t.index ["user_id"], name: "index_api_keys_on_user_id", unique: true
  end

  create_table "artist_urls", id: :serial, force: :cascade do |t|
    t.integer "artist_id", null: false
    t.text "url", null: false
    t.text "normalized_url", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_active", default: true, null: false
    t.index ["artist_id"], name: "index_artist_urls_on_artist_id"
    t.index ["normalized_url"], name: "index_artist_urls_on_normalized_url_pattern", opclass: :text_pattern_ops
    t.index ["normalized_url"], name: "index_artist_urls_on_normalized_url_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["url"], name: "index_artist_urls_on_url_trgm", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "artist_versions", id: :serial, force: :cascade do |t|
    t.integer "artist_id", null: false
    t.string "name", null: false
    t.integer "updater_id", null: false
    t.inet "updater_ip_addr", null: false
    t.boolean "is_active", default: true, null: false
    t.string "group_name", default: "", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "other_names", default: [], null: false, array: true
    t.text "urls", default: [], null: false, array: true
    t.boolean "notes_changed", default: false
    t.index ["artist_id"], name: "index_artist_versions_on_artist_id"
    t.index ["created_at"], name: "index_artist_versions_on_created_at"
    t.index ["name"], name: "index_artist_versions_on_name"
    t.index ["updater_id"], name: "index_artist_versions_on_updater_id"
    t.index ["updater_ip_addr"], name: "index_artist_versions_on_updater_ip_addr"
  end

  create_table "artists", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "creator_id", null: false
    t.boolean "is_active", default: true, null: false
    t.string "group_name", default: "", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "other_names", default: [], null: false, array: true
    t.integer "linked_user_id"
    t.boolean "is_locked", default: false
    t.index ["group_name"], name: "index_artists_on_group_name"
    t.index ["group_name"], name: "index_artists_on_group_name_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "index_artists_on_name", unique: true
    t.index ["name"], name: "index_artists_on_name_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["other_names"], name: "index_artists_on_other_names", using: :gin
  end

  create_table "avoid_posting_versions", force: :cascade do |t|
    t.bigint "updater_id", null: false
    t.bigint "avoid_posting_id", null: false
    t.inet "updater_ip_addr", null: false
    t.string "details", default: "", null: false
    t.string "staff_notes", default: "", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["avoid_posting_id"], name: "index_avoid_posting_versions_on_avoid_posting_id"
    t.index ["updater_id"], name: "index_avoid_posting_versions_on_updater_id"
  end

  create_table "avoid_postings", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.bigint "updater_id", null: false
    t.bigint "artist_id", null: false
    t.inet "creator_ip_addr", null: false
    t.inet "updater_ip_addr", null: false
    t.string "details", default: "", null: false
    t.string "staff_notes", default: "", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_avoid_postings_on_artist_id", unique: true
    t.index ["creator_id"], name: "index_avoid_postings_on_creator_id"
    t.index ["updater_id"], name: "index_avoid_postings_on_updater_id"
  end

  create_table "bans", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "reason", null: false
    t.integer "banner_id", null: false
    t.datetime "expires_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["banner_id"], name: "index_bans_on_banner_id"
    t.index ["expires_at"], name: "index_bans_on_expires_at"
    t.index ["user_id"], name: "index_bans_on_user_id"
  end

  create_table "blips", force: :cascade do |t|
    t.inet "creator_ip_addr", null: false
    t.integer "creator_id", null: false
    t.string "body", null: false
    t.integer "response_to"
    t.boolean "is_hidden", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "warning_type"
    t.integer "warning_user_id"
    t.integer "updater_id"
    t.index "lower((body)::text) gin_trgm_ops", name: "index_blips_on_lower_body_trgm", using: :gin
    t.index "to_tsvector('english'::regconfig, (body)::text)", name: "index_blips_on_to_tsvector_english_body", using: :gin
  end

  create_table "bulk_update_requests", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "forum_topic_id"
    t.text "script", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "approver_id"
    t.integer "forum_post_id"
    t.text "title"
    t.inet "user_ip_addr", default: "127.0.0.1", null: false
    t.index ["forum_post_id"], name: "index_bulk_update_requests_on_forum_post_id"
  end

  create_table "comment_votes", id: :serial, force: :cascade do |t|
    t.integer "comment_id", null: false
    t.integer "user_id", null: false
    t.integer "score", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.inet "user_ip_addr"
    t.index ["comment_id", "user_id"], name: "index_comment_votes_on_comment_id_and_user_id", unique: true
    t.index ["comment_id"], name: "index_comment_votes_on_comment_id"
    t.index ["created_at"], name: "index_comment_votes_on_created_at"
    t.index ["user_id", "id"], name: "index_comment_votes_on_user_id_and_id"
    t.index ["user_id"], name: "index_comment_votes_on_user_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "creator_id", null: false
    t.text "body", null: false
    t.inet "creator_ip_addr", null: false
    t.integer "score", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updater_id"
    t.inet "updater_ip_addr"
    t.boolean "do_not_bump_post", default: false, null: false
    t.boolean "is_hidden", default: false, null: false
    t.boolean "is_sticky", default: false, null: false
    t.integer "warning_type"
    t.integer "warning_user_id"
    t.index "lower(body) gin_trgm_ops", name: "index_comments_on_lower_body_trgm", using: :gin
    t.index "to_tsvector('english'::regconfig, body)", name: "index_comments_on_to_tsvector_english_body", using: :gin
    t.index ["creator_id", "post_id"], name: "index_comments_on_creator_id_and_post_id"
    t.index ["creator_id"], name: "index_comments_on_creator_id"
    t.index ["creator_ip_addr"], name: "index_comments_on_creator_ip_addr"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "destroyed_posts", force: :cascade do |t|
    t.integer "post_id", null: false
    t.string "md5", null: false
    t.integer "destroyer_id", null: false
    t.inet "destroyer_ip_addr", null: false
    t.integer "uploader_id"
    t.inet "uploader_ip_addr"
    t.datetime "upload_date", precision: nil
    t.json "post_data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reason", default: "", null: false
    t.boolean "notify", default: true, null: false
  end

  create_table "dmail_filters", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "words", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_dmail_filters_on_user_id", unique: true
  end

  create_table "dmails", id: :serial, force: :cascade do |t|
    t.integer "owner_id", null: false
    t.integer "from_id", null: false
    t.integer "to_id", null: false
    t.text "title", null: false
    t.text "body", null: false
    t.boolean "is_read", default: false, null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.inet "creator_ip_addr", null: false
    t.index "lower(body) gin_trgm_ops", name: "index_dmails_on_lower_body_trgm", using: :gin
    t.index "to_tsvector('english'::regconfig, body)", name: "index_dmails_on_to_tsvector_english_body", using: :gin
    t.index ["creator_ip_addr"], name: "index_dmails_on_creator_ip_addr"
    t.index ["id", "owner_id", "to_id", "is_deleted"], name: "index_dmails_for_inbox"
    t.index ["is_deleted"], name: "index_dmails_on_is_deleted"
    t.index ["is_read"], name: "index_dmails_on_is_read"
    t.index ["owner_id"], name: "index_dmails_on_owner_id"
  end

  create_table "edit_histories", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "body", null: false
    t.text "subject"
    t.string "versionable_type", limit: 100, null: false
    t.integer "versionable_id", null: false
    t.integer "version", null: false
    t.inet "ip_addr", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_edit_histories_on_user_id"
    t.index ["versionable_id", "versionable_type"], name: "index_edit_histories_on_versionable_id_and_versionable_type"
  end

  create_table "email_blacklists", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "domain", null: false
    t.integer "creator_id", null: false
    t.string "reason", null: false
  end

  create_table "exception_logs", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "class_name", null: false
    t.inet "ip_addr", null: false
    t.string "version", null: false
    t.text "extra_params"
    t.text "message", null: false
    t.text "trace", null: false
    t.uuid "code", null: false
    t.integer "user_id"
    t.index ["code"], name: "index_exception_logs_on_code"
    t.index ["user_id"], name: "index_exception_logs_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.index ["post_id"], name: "index_favorites_on_post_id"
    t.index ["user_id", "created_at"], name: "index_favorites_on_user_id_and_created_at"
    t.index ["user_id", "post_id"], name: "index_favorites_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "forum_categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "cat_order"
    t.integer "can_view", default: 20, null: false
    t.integer "can_create", default: 20, null: false
    t.integer "can_reply", default: 20, null: false
  end

  create_table "forum_post_votes", force: :cascade do |t|
    t.integer "forum_post_id", null: false
    t.integer "creator_id", null: false
    t.integer "score", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["forum_post_id", "creator_id"], name: "index_forum_post_votes_on_forum_post_id_and_creator_id", unique: true
    t.index ["forum_post_id"], name: "index_forum_post_votes_on_forum_post_id"
  end

  create_table "forum_posts", id: :serial, force: :cascade do |t|
    t.integer "topic_id", null: false
    t.integer "creator_id", null: false
    t.integer "updater_id", null: false
    t.text "body", null: false
    t.boolean "is_hidden", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.inet "creator_ip_addr"
    t.integer "warning_type"
    t.integer "warning_user_id"
    t.index "lower(body) gin_trgm_ops", name: "index_forum_posts_on_lower_body_trgm", using: :gin
    t.index "to_tsvector('english'::regconfig, body)", name: "index_forum_posts_on_to_tsvector_english_body", using: :gin
    t.index ["creator_id"], name: "index_forum_posts_on_creator_id"
    t.index ["topic_id"], name: "index_forum_posts_on_topic_id"
  end

  create_table "forum_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "forum_topic_id"
    t.datetime "last_read_at", precision: nil
    t.string "delete_key"
    t.index ["forum_topic_id"], name: "index_forum_subscriptions_on_forum_topic_id"
    t.index ["user_id"], name: "index_forum_subscriptions_on_user_id"
  end

  create_table "forum_topic_visits", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "forum_topic_id"
    t.datetime "last_read_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["forum_topic_id"], name: "index_forum_topic_visits_on_forum_topic_id"
    t.index ["last_read_at"], name: "index_forum_topic_visits_on_last_read_at"
    t.index ["user_id"], name: "index_forum_topic_visits_on_user_id"
  end

  create_table "forum_topics", id: :serial, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.integer "updater_id", null: false
    t.string "title", null: false
    t.integer "response_count", default: 0, null: false
    t.boolean "is_sticky", default: false, null: false
    t.boolean "is_locked", default: false, null: false
    t.boolean "is_hidden", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "category_id", default: 0, null: false
    t.inet "creator_ip_addr", null: false
    t.index "lower((title)::text) gin_trgm_ops", name: "index_forum_topics_on_lower_title_trgm", using: :gin
    t.index "to_tsvector('english'::regconfig, (title)::text)", name: "index_forum_topics_on_to_tsvector_english_title", using: :gin
    t.index ["creator_id"], name: "index_forum_topics_on_creator_id"
    t.index ["is_sticky", "updated_at"], name: "index_forum_topics_on_is_sticky_and_updated_at"
    t.index ["updated_at"], name: "index_forum_topics_on_updated_at"
  end

  create_table "help_pages", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name", null: false
    t.string "wiki_page", null: false
    t.string "related", default: "", null: false
    t.string "title", default: "", null: false
  end

  create_table "ip_bans", id: :serial, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.inet "ip_addr", null: false
    t.text "reason", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ip_addr"], name: "index_ip_bans_on_ip_addr", unique: true
  end

  create_table "mascots", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.string "display_name", null: false
    t.string "md5", null: false
    t.string "file_ext", null: false
    t.string "background_color", default: "#012e57", null: false
    t.string "artist_url", null: false
    t.string "artist_name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "available_on", default: [], null: false, array: true
    t.string "foreground_color", default: "#0f0f0f80", null: false
    t.boolean "is_layered", default: false, null: false
    t.index ["creator_id"], name: "index_mascots_on_creator_id"
    t.index ["md5"], name: "index_mascots_on_md5", unique: true
  end

  create_table "mod_actions", id: :serial, force: :cascade do |t|
    t.integer "creator_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "action"
    t.json "values"
    t.index ["action"], name: "index_mod_actions_on_action"
  end

  create_table "news_updates", id: :serial, force: :cascade do |t|
    t.text "message", null: false
    t.integer "creator_id", null: false
    t.integer "updater_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_at"], name: "index_news_updates_on_created_at"
  end

  create_table "note_versions", id: :serial, force: :cascade do |t|
    t.integer "note_id", null: false
    t.integer "post_id", null: false
    t.integer "updater_id", null: false
    t.inet "updater_ip_addr", null: false
    t.integer "x", null: false
    t.integer "y", null: false
    t.integer "width", null: false
    t.integer "height", null: false
    t.boolean "is_active", default: true, null: false
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "version", null: false
    t.index ["created_at"], name: "index_note_versions_on_created_at"
    t.index ["note_id"], name: "index_note_versions_on_note_id"
    t.index ["post_id"], name: "index_note_versions_on_post_id"
    t.index ["updater_id", "post_id"], name: "index_note_versions_on_updater_id_and_post_id"
    t.index ["updater_ip_addr"], name: "index_note_versions_on_updater_ip_addr"
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.integer "post_id", null: false
    t.integer "x", null: false
    t.integer "y", null: false
    t.integer "width", null: false
    t.integer "height", null: false
    t.boolean "is_active", default: true, null: false
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "version", default: 0, null: false
    t.index "lower(body) gin_trgm_ops", name: "index_notes_on_lower_body_trgm", using: :gin
    t.index "to_tsvector('english'::regconfig, body)", name: "index_notes_on_to_tsvector_english_body", using: :gin
    t.index ["creator_id", "post_id"], name: "index_notes_on_creator_id_and_post_id"
    t.index ["post_id"], name: "index_notes_on_post_id"
  end

  create_table "pool_versions", force: :cascade do |t|
    t.integer "pool_id", null: false
    t.integer "post_ids", default: [], null: false, array: true
    t.integer "added_post_ids", default: [], null: false, array: true
    t.integer "removed_post_ids", default: [], null: false, array: true
    t.integer "updater_id"
    t.inet "updater_ip_addr"
    t.text "description"
    t.boolean "description_changed", default: false, null: false
    t.text "name"
    t.boolean "name_changed", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_active", default: true, null: false
    t.string "category"
    t.integer "version", default: 1, null: false
    t.index ["pool_id"], name: "index_pool_versions_on_pool_id"
    t.index ["updater_id"], name: "index_pool_versions_on_updater_id"
    t.index ["updater_ip_addr"], name: "index_pool_versions_on_updater_ip_addr"
  end

  create_table "pools", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "creator_id", null: false
    t.text "description"
    t.boolean "is_active", default: true, null: false
    t.integer "post_ids", default: [], null: false, array: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "category", default: "series", null: false
    t.index "lower((name)::text) gin_trgm_ops", name: "index_pools_on_name_trgm", using: :gin
    t.index "lower((name)::text)", name: "index_pools_on_lower_name"
    t.index ["creator_id"], name: "index_pools_on_creator_id"
    t.index ["name"], name: "index_pools_on_name"
    t.index ["updated_at"], name: "index_pools_on_updated_at"
  end

  create_table "post_approvals", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["post_id"], name: "index_post_approvals_on_post_id"
    t.index ["user_id"], name: "index_post_approvals_on_user_id"
  end

  create_table "post_disapprovals", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.string "reason", default: "legacy"
    t.text "message"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["post_id"], name: "index_post_disapprovals_on_post_id"
    t.index ["user_id"], name: "index_post_disapprovals_on_user_id"
  end

  create_table "post_events", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.bigint "post_id", null: false
    t.integer "action", null: false
    t.jsonb "extra_data", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["creator_id"], name: "index_post_events_on_creator_id"
    t.index ["post_id"], name: "index_post_events_on_post_id"
  end

  create_table "post_flags", id: :serial, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "creator_id", null: false
    t.inet "creator_ip_addr", null: false
    t.text "reason"
    t.boolean "is_resolved", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil
    t.boolean "is_deletion", default: false, null: false
    t.string "note"
    t.index "to_tsvector('english'::regconfig, reason)", name: "index_post_flags_on_reason_tsvector", using: :gin
    t.index ["creator_id"], name: "index_post_flags_on_creator_id"
    t.index ["creator_ip_addr"], name: "index_post_flags_on_creator_ip_addr"
    t.index ["post_id"], name: "index_post_flags_on_post_id"
  end

  create_table "post_replacements2", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_id", null: false
    t.integer "creator_id", null: false
    t.inet "creator_ip_addr", null: false
    t.integer "approver_id"
    t.string "file_ext", null: false
    t.integer "file_size", null: false
    t.integer "image_height", null: false
    t.integer "image_width", null: false
    t.string "md5", null: false
    t.string "source"
    t.string "file_name"
    t.string "storage_id", null: false
    t.string "status", default: "pending", null: false
    t.string "reason", null: false
    t.boolean "protected", default: false, null: false
    t.integer "uploader_id_on_approve"
    t.boolean "penalize_uploader_on_approve"
    t.index ["creator_id"], name: "index_post_replacements2_on_creator_id"
    t.index ["post_id"], name: "index_post_replacements2_on_post_id"
  end

  create_table "post_report_reasons", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "reason", null: false
    t.integer "creator_id", null: false
    t.inet "creator_ip_addr"
    t.string "description", null: false
  end

  create_table "post_set_maintainers", force: :cascade do |t|
    t.integer "post_set_id", null: false
    t.integer "user_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "post_sets", force: :cascade do |t|
    t.string "name", null: false
    t.string "shortname", null: false
    t.text "description", default: "", null: false
    t.boolean "is_public", default: false, null: false
    t.boolean "transfer_on_delete", default: false, null: false
    t.integer "creator_id", null: false
    t.inet "creator_ip_addr"
    t.integer "post_ids", default: [], null: false, array: true
    t.integer "post_count", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["post_ids"], name: "index_post_sets_on_post_ids", using: :gin
  end

  create_table "post_versions", force: :cascade do |t|
    t.integer "post_id", null: false
    t.text "tags", null: false
    t.text "added_tags", default: [], null: false, array: true
    t.text "removed_tags", default: [], null: false, array: true
    t.text "locked_tags"
    t.text "added_locked_tags", default: [], null: false, array: true
    t.text "removed_locked_tags", default: [], null: false, array: true
    t.integer "updater_id", default: 0, null: false
    t.inet "updater_ip_addr", default: "127.0.0.1", null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.string "rating", limit: 1
    t.boolean "rating_changed", default: false, null: false
    t.integer "parent_id"
    t.boolean "parent_changed", default: false, null: false
    t.text "source"
    t.boolean "source_changed", default: false, null: false
    t.text "description"
    t.boolean "description_changed", default: false, null: false
    t.integer "version", default: 1, null: false
    t.string "reason"
    t.boolean "is_hidden", default: false, null: false
    t.index ["post_id"], name: "index_post_versions_on_post_id"
    t.index ["updated_at"], name: "index_post_versions_on_updated_at"
    t.index ["updater_id"], name: "index_post_versions_on_updater_id"
    t.index ["updater_ip_addr"], name: "index_post_versions_on_updater_ip_addr"
  end

  create_table "post_votes", id: :serial, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.integer "score", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.inet "user_ip_addr"
    t.index ["post_id"], name: "index_post_votes_on_post_id"
    t.index ["user_id", "created_at"], name: "index_post_votes_on_user_id_and_created_at"
    t.index ["user_id", "id"], name: "index_post_votes_on_user_id_and_id"
    t.index ["user_id", "post_id"], name: "index_post_votes_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_post_votes_on_user_id"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil
    t.integer "up_score", default: 0, null: false
    t.integer "down_score", default: 0, null: false
    t.integer "score", default: 0, null: false
    t.string "source", null: false
    t.string "md5", null: false
    t.string "rating", limit: 1, default: "q", null: false
    t.boolean "is_note_locked", default: false, null: false
    t.boolean "is_rating_locked", default: false, null: false
    t.boolean "is_status_locked", default: false, null: false
    t.boolean "is_pending", default: false, null: false
    t.boolean "is_flagged", default: false, null: false
    t.boolean "is_deleted", default: false, null: false
    t.integer "uploader_id", null: false
    t.inet "uploader_ip_addr", null: false
    t.integer "approver_id"
    t.text "fav_string", default: "", null: false
    t.text "pool_string", default: "", null: false
    t.datetime "last_noted_at", precision: nil
    t.datetime "last_comment_bumped_at", precision: nil
    t.integer "fav_count", default: 0, null: false
    t.text "tag_string", default: "", null: false
    t.integer "tag_count", default: 0, null: false
    t.integer "tag_count_general", default: 0, null: false
    t.integer "tag_count_artist", default: 0, null: false
    t.integer "tag_count_character", default: 0, null: false
    t.integer "tag_count_copyright", default: 0, null: false
    t.string "file_ext", null: false
    t.integer "file_size", null: false
    t.integer "image_width", null: false
    t.integer "image_height", null: false
    t.integer "parent_id"
    t.boolean "has_children", default: false, null: false
    t.datetime "last_commented_at", precision: nil
    t.boolean "has_active_children", default: false, null: false
    t.bigint "bit_flags", default: 0, null: false
    t.integer "tag_count_meta", default: 0, null: false
    t.text "locked_tags"
    t.integer "tag_count_species", default: 0, null: false
    t.integer "tag_count_invalid", default: 0, null: false
    t.text "description", default: "", null: false
    t.integer "comment_count", default: 0, null: false
    t.bigserial "change_seq", null: false
    t.integer "tag_count_lore", default: 0, null: false
    t.string "bg_color"
    t.decimal "duration"
    t.boolean "is_comment_disabled", default: false, null: false
    t.boolean "is_comment_locked", default: false, null: false
    t.integer "tag_count_contributor", default: 0, null: false
    t.jsonb "video_samples", default: {}, null: false
    t.index "string_to_array(tag_string, ' '::text)", name: "index_posts_on_string_to_array_tag_string", using: :gin
    t.index ["change_seq"], name: "index_posts_on_change_seq", unique: true
    t.index ["created_at"], name: "index_posts_on_created_at"
    t.index ["is_flagged"], name: "index_posts_on_is_flagged", where: "(is_flagged = true)"
    t.index ["is_pending"], name: "index_posts_on_is_pending", where: "(is_pending = true)"
    t.index ["md5"], name: "index_posts_on_md5", unique: true
    t.index ["parent_id"], name: "index_posts_on_parent_id"
    t.index ["uploader_id"], name: "index_posts_on_uploader_id"
    t.index ["uploader_ip_addr"], name: "index_posts_on_uploader_ip_addr"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  create_table "staff_audit_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "action", default: "unknown_action", null: false
    t.json "values"
    t.index ["user_id"], name: "index_staff_audit_logs_on_user_id"
  end

  create_table "staff_notes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "creator_id", null: false
    t.string "body"
    t.boolean "is_deleted", default: false, null: false
    t.bigint "updater_id", null: false
    t.index ["creator_id"], name: "index_staff_notes_on_creator_id"
    t.index ["updater_id"], name: "index_staff_notes_on_updater_id"
    t.index ["user_id"], name: "index_staff_notes_on_user_id"
  end

  create_table "tag_aliases", id: :serial, force: :cascade do |t|
    t.string "antecedent_name", null: false
    t.string "consequent_name", null: false
    t.integer "creator_id", null: false
    t.inet "creator_ip_addr", null: false
    t.integer "forum_topic_id"
    t.text "status", default: "pending", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "post_count", default: 0, null: false
    t.integer "approver_id"
    t.integer "forum_post_id"
    t.text "reason", default: "", null: false
    t.index ["antecedent_name"], name: "index_tag_aliases_on_antecedent_name"
    t.index ["antecedent_name"], name: "index_tag_aliases_on_antecedent_name_pattern", opclass: :text_pattern_ops
    t.index ["consequent_name"], name: "index_tag_aliases_on_consequent_name"
    t.index ["forum_post_id"], name: "index_tag_aliases_on_forum_post_id"
    t.index ["post_count"], name: "index_tag_aliases_on_post_count"
  end

  create_table "tag_implications", id: :serial, force: :cascade do |t|
    t.string "antecedent_name", null: false
    t.string "consequent_name", null: false
    t.integer "creator_id", null: false
    t.inet "creator_ip_addr", null: false
    t.integer "forum_topic_id"
    t.text "status", default: "pending", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "approver_id"
    t.integer "forum_post_id"
    t.text "descendant_names", default: [], array: true
    t.text "reason", default: "", null: false
    t.index ["antecedent_name"], name: "index_tag_implications_on_antecedent_name"
    t.index ["consequent_name"], name: "index_tag_implications_on_consequent_name"
    t.index ["forum_post_id"], name: "index_tag_implications_on_forum_post_id"
  end

  create_table "tag_rel_undos", force: :cascade do |t|
    t.string "tag_rel_type"
    t.bigint "tag_rel_id"
    t.json "undo_data"
    t.boolean "applied", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_rel_type", "tag_rel_id"], name: "index_tag_rel_undos_on_tag_rel_type_and_tag_rel_id"
  end

  create_table "tag_type_versions", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "old_type", null: false
    t.integer "new_type", null: false
    t.boolean "is_locked", null: false
    t.integer "tag_id", null: false
    t.integer "creator_id", null: false
    t.index ["creator_id"], name: "index_tag_type_versions_on_creator_id"
    t.index ["tag_id"], name: "index_tag_type_versions_on_tag_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "post_count", default: 0, null: false
    t.integer "category", limit: 2, default: 0, null: false
    t.text "related_tags"
    t.datetime "related_tags_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_locked", default: false, null: false
    t.index "regexp_replace((name)::text, '([a-z0-9])[a-z0-9'']*($|[^a-z0-9'']+)'::text, '\\1'::text, 'g'::text) gin_trgm_ops", name: "index_tags_on_name_prefix", using: :gin
    t.index ["name"], name: "index_tags_on_name", unique: true
    t.index ["name"], name: "index_tags_on_name_pattern", opclass: :text_pattern_ops
    t.index ["name"], name: "index_tags_on_name_trgm", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "takedowns", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "creator_id"
    t.inet "creator_ip_addr", null: false
    t.integer "approver_id"
    t.string "status", default: "pending"
    t.string "vericode", null: false
    t.string "source"
    t.string "email"
    t.text "reason"
    t.boolean "reason_hidden", default: false, null: false
    t.text "notes", default: "none", null: false
    t.text "instructions"
    t.text "post_ids", default: ""
    t.text "del_post_ids", default: ""
    t.integer "post_count", default: 0, null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "creator_id", null: false
    t.inet "creator_ip_addr", null: false
    t.integer "disp_id", null: false
    t.string "qtype", null: false
    t.string "status", default: "pending", null: false
    t.string "reason"
    t.string "report_reason"
    t.string "response", default: "", null: false
    t.integer "handler_id", default: 0, null: false
    t.integer "claimant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "accused_id"
  end

  create_table "upload_whitelists", force: :cascade do |t|
    t.string "note"
    t.string "reason"
    t.boolean "allowed", default: true, null: false
    t.boolean "hidden", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "domain"
    t.string "path", default: "\\/.+"
  end

  create_table "uploads", id: :serial, force: :cascade do |t|
    t.text "source"
    t.string "rating", limit: 1, null: false
    t.integer "uploader_id", null: false
    t.inet "uploader_ip_addr", null: false
    t.text "tag_string", null: false
    t.text "status", default: "pending", null: false
    t.text "backtrace"
    t.integer "post_id"
    t.string "md5_confirmation"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "parent_id"
    t.string "md5"
    t.string "file_ext"
    t.integer "file_size"
    t.integer "image_width"
    t.integer "image_height"
    t.text "description", default: "", null: false
    t.index ["source"], name: "index_uploads_on_source"
    t.index ["uploader_id"], name: "index_uploads_on_uploader_id"
    t.index ["uploader_ip_addr"], name: "index_uploads_on_uploader_ip_addr"
  end

  create_table "user_feedback", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "creator_id", null: false
    t.string "category", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.inet "creator_ip_addr"
    t.integer "updater_id"
    t.boolean "is_deleted", default: false, null: false
    t.index "lower(body) gin_trgm_ops", name: "index_user_feedback_on_lower_body_trgm", using: :gin
    t.index "to_tsvector('english'::regconfig, body)", name: "index_user_feedback_on_to_tsvector_english_body", using: :gin
    t.index ["created_at"], name: "index_user_feedback_on_created_at"
    t.index ["creator_id"], name: "index_user_feedback_on_creator_id"
    t.index ["creator_ip_addr"], name: "index_user_feedback_on_creator_ip_addr"
    t.index ["user_id"], name: "index_user_feedback_on_user_id"
  end

  create_table "user_name_change_requests", id: :serial, force: :cascade do |t|
    t.string "status", default: "pending", null: false
    t.integer "user_id", null: false
    t.integer "approver_id"
    t.string "original_name"
    t.string "desired_name"
    t.text "change_reason"
    t.text "rejection_reason"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["original_name"], name: "index_user_name_change_requests_on_original_name"
    t.index ["user_id"], name: "index_user_name_change_requests_on_user_id"
  end

  create_table "user_password_reset_nonces", id: :serial, force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id", null: false
  end

  create_table "user_statuses", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id", null: false
    t.integer "post_count", default: 0, null: false
    t.integer "post_deleted_count", default: 0, null: false
    t.integer "post_update_count", default: 0, null: false
    t.integer "post_flag_count", default: 0, null: false
    t.integer "favorite_count", default: 0, null: false
    t.integer "wiki_edit_count", default: 0, null: false
    t.integer "note_count", default: 0, null: false
    t.integer "forum_post_count", default: 0, null: false
    t.integer "comment_count", default: 0, null: false
    t.integer "pool_edit_count", default: 0, null: false
    t.integer "blip_count", default: 0, null: false
    t.integer "set_count", default: 0, null: false
    t.integer "artist_edit_count", default: 0, null: false
    t.integer "own_post_replaced_count", default: 0
    t.integer "own_post_replaced_penalize_count", default: 0
    t.integer "post_replacement_rejected_count", default: 0
    t.integer "ticket_count", default: 0, null: false
    t.index ["user_id"], name: "index_user_statuses_on_user_id", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil
    t.string "name", null: false
    t.string "password_hash", null: false
    t.string "email"
    t.string "email_verification_key"
    t.integer "level", default: 20, null: false
    t.integer "base_upload_limit", default: 10, null: false
    t.datetime "last_logged_in_at", precision: nil
    t.datetime "last_forum_read_at", precision: nil
    t.text "recent_tags"
    t.integer "comment_threshold", default: -2, null: false
    t.string "default_image_size", default: "large", null: false
    t.text "favorite_tags"
    t.text "blacklisted_tags", default: "spoilers\nguro\nscat\nfurry -rating:s"
    t.string "time_zone", default: "Eastern Time (US & Canada)", null: false
    t.text "bcrypt_password_hash"
    t.integer "per_page", default: 75, null: false
    t.text "custom_style"
    t.bigint "bit_prefs", default: 0, null: false
    t.inet "last_ip_addr"
    t.integer "unread_dmail_count", default: 0, null: false
    t.text "profile_about", default: "", null: false
    t.text "profile_artinfo", default: "", null: false
    t.integer "avatar_id"
    t.index "lower((email)::text)", name: "index_user_lower_email"
    t.index "lower((name)::text)", name: "index_users_on_name", unique: true
    t.index "lower(profile_about) gin_trgm_ops", name: "index_users_on_lower_profile_about_trgm", using: :gin
    t.index "lower(profile_artinfo) gin_trgm_ops", name: "index_users_on_lower_profile_artinfo_trgm", using: :gin
    t.index "to_tsvector('english'::regconfig, profile_about)", name: "index_users_on_to_tsvector_english_profile_about", using: :gin
    t.index "to_tsvector('english'::regconfig, profile_artinfo)", name: "index_users_on_to_tsvector_english_profile_artinfo", using: :gin
    t.index ["email"], name: "index_users_on_email"
    t.index ["id"], name: "index_users_on_bitprefs_both", where: "((bit_prefs & (98304)::bigint) = 98304)"
    t.index ["id"], name: "index_users_on_bitprefs_cap", where: "((bit_prefs & (32768)::bigint) = 32768)"
    t.index ["id"], name: "index_users_on_bitprefs_cuf", where: "((bit_prefs & (65536)::bigint) = 65536)"
    t.index ["last_ip_addr"], name: "index_users_on_last_ip_addr", where: "(last_ip_addr IS NOT NULL)"
  end

  create_table "wiki_page_versions", id: :serial, force: :cascade do |t|
    t.integer "wiki_page_id", null: false
    t.integer "updater_id", null: false
    t.inet "updater_ip_addr", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.boolean "is_locked", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "other_names", default: [], null: false, array: true
    t.boolean "is_deleted", default: false, null: false
    t.string "reason"
    t.string "parent"
    t.index ["created_at"], name: "index_wiki_page_versions_on_created_at"
    t.index ["updater_ip_addr"], name: "index_wiki_page_versions_on_updater_ip_addr"
    t.index ["wiki_page_id"], name: "index_wiki_page_versions_on_wiki_page_id"
  end

  create_table "wiki_pages", id: :serial, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.boolean "is_locked", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updater_id"
    t.text "other_names", default: [], null: false, array: true
    t.boolean "is_deleted", default: false, null: false
    t.string "parent"
    t.index "lower((title)::text) gin_trgm_ops", name: "index_wiki_pages_on_lower_title_trgm", using: :gin
    t.index "lower(body) gin_trgm_ops", name: "index_wiki_pages_on_lower_body_trgm", using: :gin
    t.index "to_tsvector('english'::regconfig, body)", name: "index_wiki_pages_on_to_tsvector_english_body", using: :gin
    t.index ["other_names"], name: "index_wiki_pages_on_other_names", using: :gin
    t.index ["title"], name: "index_wiki_pages_on_title", unique: true
    t.index ["title"], name: "index_wiki_pages_on_title_pattern", opclass: :text_pattern_ops
    t.index ["updated_at"], name: "index_wiki_pages_on_updated_at"
  end

  add_foreign_key "avoid_posting_versions", "avoid_postings"
  add_foreign_key "avoid_posting_versions", "users", column: "updater_id"
  add_foreign_key "avoid_postings", "artists"
  add_foreign_key "avoid_postings", "users", column: "creator_id"
  add_foreign_key "avoid_postings", "users", column: "updater_id"
  add_foreign_key "blips", "users", column: "updater_id"
  add_foreign_key "exception_logs", "users"
  add_foreign_key "favorites", "posts"
  add_foreign_key "favorites", "users"
  add_foreign_key "mascots", "users", column: "creator_id"
  add_foreign_key "post_events", "users", column: "creator_id"
  add_foreign_key "staff_audit_logs", "users"
  add_foreign_key "staff_notes", "users"
  add_foreign_key "staff_notes", "users", column: "updater_id"
  add_foreign_key "tickets", "users", column: "accused_id"
  add_foreign_key "user_feedback", "users", column: "updater_id"
end
