class CreateMates < ActiveRecord::Migration
  def self.up
    create_table :mates do |t|
      t.integer :goodreads_id, :null => false
      t.string :name, :null => false
      t.string :postal_code, :limit => 12
      t.string :location
      t.date :birthday
      t.string :gender, :limit => 1
      t.string :looking_for_gender, :limit => 1
      t.string :profile_photo_url, :limit => 255
      t.string :thumbnail_url, :limit => 255
      t.integer :books_count
      t.string :favorite_book
      t.string :hobbies
      t.timestamps
    end
    add_index :mates, :goodreads_id, :unique => true
  end

  def self.down
    drop_table :mates
  end
end
