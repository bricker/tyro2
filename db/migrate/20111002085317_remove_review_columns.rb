class RemoveReviewColumns < ActiveRecord::Migration
  def self.up
    drop_table :reviews if table_exists?(:reviews)
    drop_table :reviews_tags if table_exists?(:reviews_tags)
    drop_table :review_comments if table_exists?(:review_comments)
  
  end

  def self.down
    create_table "review_comments", :force => true do |t|
      t.integer  "review_id"
      t.string   "name"
      t.text     "body"
      t.boolean  "approved",   :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "reviews", :force => true do |t|
      t.string   "title"
      t.text     "body"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "tags_string"
      t.string   "avatar_file_name"
      t.string   "avatar_content_type"
      t.integer  "avatar_file_size"
      t.datetime "avatar_updated_at"
    end

    create_table "reviews_tags", :id => false, :force => true do |t|
      t.integer "review_id"
      t.integer "tag_id"
    end
  end
end
