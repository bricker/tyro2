class CreateSignups < ActiveRecord::Migration
  def self.up
    create_table :signups do |t|
      t.string :name
      t.integer :student_id
      t.string :email
      t.string :phone_number
      t.integer :semester_level
      t.string :major
      t.text :interest
      t.string :preferred_genres
      t.timestamps
    end
  end

  def self.down
    drop_table :signups
  end
end
