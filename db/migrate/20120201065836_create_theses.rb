class CreateTheses < ActiveRecord::Migration
  def self.up
    create_table :theses do |t|
      t.string :name
      t.integer :owner_id
      t.string :owner_type
      t.string :description
      t.datetime :date_of_publish
      t.integer :no_of_pages
      t.references :category
      t.boolean :is_deleted, :default => false
      t.timestamps
    end
  end
  def self.down
    drop_table :theses
  end
end
