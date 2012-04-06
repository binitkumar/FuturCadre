class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :tag_line
      t.string :city
      t.string :twitter_link
      t.string :dig_link
      t.string :aol_link
      t.text :description
      t.text :research
      t.text :skill
      t.integer :owner_id
      t.string :owner_type
      t.boolean :is_deleted, :default => false
      t.references :country, :city, :region, :category

      t.timestamps
    end
  end
  def self.down
    drop_table :projects
  end
end
