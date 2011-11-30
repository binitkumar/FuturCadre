class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.integer :employer_id
			t.string :employer_type
      t.string :description
			t.references :category, :country, :region, :city

      t.timestamps
    end
		add_index :jobs, :name
		add_index :jobs, :category_id
		add_index :jobs, :country_id
		add_index :jobs, :region_id
		add_index :jobs, :city_id
	end
end
