class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :owner_id
      t.text :description
      t.string :tag_line
      t.text :presentation
      t.text :research
      t.integer :no_of_pages
      t.references :category, :country, :region, :city
      t.string :is_deleted, :default => 'false'

      t.timestamps
    end
  end
end
