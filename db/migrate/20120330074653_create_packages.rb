class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|

      t.string :name
      t.string :description
      t.integer :price
      t.integer :no_of_jobs
      t.integer :no_of_searches
      t.datetime :start_date
      t.datetime :expiry_date



      t.timestamps
    end
  end
end
