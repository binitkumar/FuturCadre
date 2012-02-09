class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :owner_id
      t.string :description
      t.datetime :date_of_publish
      t.integer :no_of_pages
      t.references :category
      t.string :is_deleted, :default => 'false'

      t.timestamps
    end
  end
end