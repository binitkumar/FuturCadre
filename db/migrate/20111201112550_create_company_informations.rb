class CreateCompanyInformations < ActiveRecord::Migration
  def self.up
    create_table :company_informations do |t|
      t.integer :profile_id
    	t.string :name
      t.text   :description
			t.integer :phone
			t.integer :fax
			t.text :email
			t.text :web_site
			t.text :address
			t.integer :country_id
			t.integer :region_id
			t.integer :city_id
      t.references :sector

      t.timestamps
    end
  end
  def self.down
    drop_table :company_informations
  end
end
