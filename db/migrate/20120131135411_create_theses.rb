class CreateTheses < ActiveRecord::Migration
  def change
    create_table :theses do |t|
      t.string :name
      t.string :description
      t.datetime :date_of_publish
      t.integer :no_of_pages

      t.timestamps
    end
  end
end
