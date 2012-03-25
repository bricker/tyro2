class AddIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :name
    add_index :songs, :title
    add_index :songs, :artist
    add_index :songs, :album
  end

  def self.down
  end
end
