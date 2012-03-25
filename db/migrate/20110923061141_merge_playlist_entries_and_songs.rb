class MergePlaylistEntriesAndSongs < ActiveRecord::Migration
  def self.up
   add_column :playlist_entries, :title, :string
   add_column :playlist_entries, :artist, :string
   add_column :playlist_entries, :album, :string
    
    PlaylistEntry.all.each do |entry|
      entry.title = entry.song.title
      entry.artist = entry.song.artist
      entry.album = entry.song.album
      entry.save
    end
    
    remove_column :playlist_entries, :song_id
    remove_index :playlist_entries, "song_id_and_schedule_event_id"
    add_index "playlist_entries", ["title", "album", "artist"]
    drop_table :songs
  end

  def self.down
    remove_column :playlist_entries, :title
    remove_column :playlist_entries, :artist
    remove_column :playlist_entries, :album
    
    add_column :playlist_entries, :song_id
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.timestamps
    end
  end
  
end
