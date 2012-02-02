class CreateTheses < ActiveRecord::Migration
  def change
    create_table :theses do |t|
      t.string :name
      t.integer :owner_id
      t.string :description
      t.datetime :date_of_publish
      t.integer :no_of_pages
      t.references :category
      t.timestamps
    end
  end
end