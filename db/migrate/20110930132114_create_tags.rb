class CreateTags < ActiveRecord::Migration
  def self.up
    drop_table :shows_tags
    
    create_table :tags, :force => true do |t|
      t.string :name
      t.timestamps
    end
    
    add_index :tags, :name
    rename_column :shows, :tags_string, :old_tags_string
  end

  def self.down
    drop_table :tags
  end
end
