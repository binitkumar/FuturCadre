class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.integer :employer_id
			t.string :employer_type
      t.string :description
      t.string :comp_annual
      t.string :comp_bonus
      t.string :comp_commission
      t.datetime :date_of_expiry
			t.references :category, :country, :region, :city, :contract, :period

      t.timestamps
    end
		add_index :jobs, :name
		add_index :jobs, :category_id
		add_index :jobs, :country_id
		add_index :jobs, :region_id
		add_index :jobs, :city_id
	end
end
