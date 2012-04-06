class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :name
      t.references :imageable, :polymorphic => true
      t.string :content_type
      t.string :image_file_name
      t.integer :image_file_size
      t.string :image_content_type
      t.datetime :image_updated_at
      t.timestamps
    end
  end
  def self.down
    drop_table :photos
  end
end
