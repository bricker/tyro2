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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120325114304) do

  create_table "comments", :force => true do |t|
    t.integer  "commenter_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table "completed_training_steps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "training_step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_users", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  create_table "forums", :force => true do |t|
    t.string   "subject"
    t.string   "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
  end

  add_index "messages", ["topic_id", "created_at"], :name => "index_messages_on_topic_id_and_created_at"

  create_table "news_posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "permission_id"
  end

  add_index "permissions_users", ["user_id", "permission_id"], :name => "index_permissions_users_on_user_id_and_permission_id"

  create_table "playlist_entries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "schedule_event_id"
    t.string   "title"
    t.string   "artist"
    t.string   "album"
  end

  add_index "playlist_entries", ["title", "album", "artist"], :name => "index_playlist_entries_on_title_and_album_and_artist"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "show_id"
  end

  add_index "posts", ["show_id"], :name => "index_posts_on_show_id"

  create_table "problem_reports", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "closed",      :default => false
    t.string   "category"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "read_marks", :force => true do |t|
    t.integer  "readable_id"
    t.integer  "user_id",                     :null => false
    t.string   "readable_type", :limit => 20, :null => false
    t.datetime "timestamp"
  end

  add_index "read_marks", ["user_id", "readable_type", "readable_id"], :name => "index_read_marks_on_user_id_and_readable_type_and_readable_id"

  create_table "roles", :force => true do |t|
    t.string "title"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id"

  create_table "schedule_events", :force => true do |t|
    t.integer  "schedulable_id"
    t.string   "schedulable_type"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "recurring",           :default => false
    t.integer  "first_occurrence_id"
    t.string   "event_type"
  end

  add_index "schedule_events", ["schedulable_id", "schedulable_type"], :name => "index_schedule_events_on_schedulable_id_and_schedulable_type"

  create_table "shouts", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shows", :force => true do |t|
    t.string   "title"
    t.string   "genre"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_slug"
    t.boolean  "active",              :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "old_tags_string",     :default => ""
    t.datetime "deleted_at"
  end

  add_index "shows", ["title"], :name => "index_shows_on_title"

  create_table "shows_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "show_id"
  end

  add_index "shows_users", ["show_id", "user_id"], :name => "index_shows_users_on_show_id_and_user_id"

  create_table "signups", :force => true do |t|
    t.string   "name"
    t.integer  "student_id"
    t.string   "email"
    t.string   "phone_number"
    t.integer  "semester_level"
    t.string   "major"
    t.text     "interest"
    t.string   "preferred_genres"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "preferred_slots"
  end

  create_table "static_contents", :force => true do |t|
    t.string   "text_id"
    t.string   "description"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "strikes", :force => true do |t|
    t.integer  "sinner_id"
    t.integer  "striker_id"
    t.integer  "severity"
    t.boolean  "resolved",   :default => false
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "offense_on"
  end

  add_index "strikes", ["sinner_id"], :name => "index_strikes_on_sinner_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "subscribable_id"
    t.string   "subscribable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["subscriber_id", "subscribable_id", "subscribable_type"], :name => "index_subscriptions_on_subscriber_and_subscribable"

  create_table "substitutions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "show_id"
    t.integer  "episode_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "global",         :default => false
    t.boolean  "locked",         :default => false
    t.boolean  "sticky",         :default => false
    t.integer  "messages_count"
  end

  add_index "topics", ["forum_id", "updated_at"], :name => "index_topics_on_forum_id_and_updated_at"

  create_table "training_steps", :force => true do |t|
    t.string   "title"
    t.string   "text_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "dj_name"
    t.text     "about"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number",                :default => "no info"
    t.string   "aim_screenname",              :default => "no info"
    t.text     "additional_contact_info"
    t.text     "signature"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "active"
    t.string   "password_reset_token"
    t.datetime "password_reset_requested_at"
    t.datetime "deleted_at"
    t.integer  "total_strikes",               :default => 0
    t.string   "password_digest"
    t.string   "facebook_uid"
  end

  add_index "users", ["email", "name"], :name => "index_users_on_email_and_name"

end
