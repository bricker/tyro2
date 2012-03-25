class DoIndexes < ActiveRecord::Migration
  def self.up
    remove_index :comments, :created_at
    add_index :comments, [:commentable_id, :commentable_type]
    
    remove_index :messages, :created_at
    add_index :messages, [:topic_id, :created_at]
    
    remove_index :songs, :title
    remove_index :songs, :artist
    remove_index :songs, :album
    add_index :songs, [:title, :album, :artist]
    
    add_index :permissions_users, [:user_id, :permission_id]
    
    add_index :playlist_entries, [:song_id, :schedule_event_id]
    
    add_index :posts, [:show_id]
    
    add_index :roles_users, [:user_id, :role_id]
    
    add_index :schedule_events, [:schedulable_id, :schedulable_type]
    
    remove_index :shows, :url_slug
    add_index :shows, :title
    
    add_index :shows_users, [:show_id, :user_id]
    
    add_index :strikes, :sinner_id
    
    add_index :subscriptions, [:subscriber_id, :subscribable_id, :subscribable_type], :name => 'index_subscriptions_on_subscriber_and_subscribable'
    
    add_index :topics, [:forum_id, :updated_at]
    
    remove_index :users, :email
    remove_index :users, :name
    add_index :users, [:email, :name]
  end

  def self.down
  end
end
