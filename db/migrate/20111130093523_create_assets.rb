class CreateAssets < ActiveRecord::Migration
def self.up
    create_table :assets do |t|
      t.references :user
      t.references :profile
      t.string :photo_file_name
      t.integer :photo_file_size
      t.string :photo_content_type
      t.datetime :photo_updated_at
      t.string :content_type
      t.boolean :is_deleted, :default => false
      t.boolean :is_publishable, :default => false
      t.timestamps
    end
end
  def self.down
    drop_table :assets
  end
end
