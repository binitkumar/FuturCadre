class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, :country, :region, :city
			t.string :first_name
			t.string :last_name
			t.text :address
			t.string :phone
      t.text   :zip_code

      t.timestamps
    end
  end
end
