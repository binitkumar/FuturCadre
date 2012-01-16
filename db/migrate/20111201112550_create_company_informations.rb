class CreateCompanyInformations < ActiveRecord::Migration
  def change
    create_table :company_informations do |t|
      t.integer :profile_id
    	t.string :name
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
end
