class RemoveTitleFromStaticContents < ActiveRecord::Migration
  def self.up
    remove_column :static_contents, :title
  end

  def self.down
    add_column :static_contents, :title, :string
  end
end
