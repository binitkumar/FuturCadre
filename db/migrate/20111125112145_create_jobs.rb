class CreateJobs < ActiveRecord::Migration
def self.up
    create_table :jobs do |t|
      t.string :name
      t.integer :employer_id
			t.string :employer_type
      t.text :description
      t.string :annual_salary,  :default => 'Non'
      t.datetime :date_of_expiry
      t.datetime :date_of_start
      t.string :publisher_email
      t.boolean :publish
     	t.references :category, :country, :region, :city, :contract, :period
      t.boolean :is_deleted, :default => false


      t.timestamps
    end
		add_index :jobs, :name
		add_index :jobs, :category_id
		add_index :jobs, :country_id
		add_index :jobs, :region_id
		add_index :jobs, :city_id
end
  def self.down
    drop_table :jobs
  end
end
