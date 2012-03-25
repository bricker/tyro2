class CreateStaticContents < ActiveRecord::Migration
  def self.up
    create_table :static_contents do |t|
      t.string :title
      t.string :text_id
      t.string :description
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :static_contents
  end
end
