class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.integer :taggable_id
      t.string :taggable_type
      t.integer :tag_id
      t.timestamps
    end
    
    add_index :taggings, [:taggable_id, :taggable_type]
    add_index :taggings, :tag_id
  end

  def self.down
    drop_table :taggings
  end
end
