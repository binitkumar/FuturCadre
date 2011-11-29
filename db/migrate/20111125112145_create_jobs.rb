class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.integer :employer_id
			t.string :employer_type
      t.string :description
      t.integer :category_id
      t.integer :country_id
      t.integer :region_id
      t.integer :city_id

      t.timestamps
    end
  end
end
