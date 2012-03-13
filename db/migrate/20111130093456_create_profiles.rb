class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, :country, :region, :city
			t.string :first_name
			t.string :last_name
			t.text :address
			t.string :phone
      t.text   :zip_code

      t.string :job_title
     # t.string :carrier_level
      #t.string:education_level
      #t.string:city
      #t.string :state
      t.string :work_authorization
      #t.string :recent_job_title
     # t.string:recent_employer
      t.string:desired_job_type
      t.string:desired_job_status
     t.integer :salary_to
      t.integer:salary_from
      t.string:currency
      t.string:salary_period
      t.boolean:willing
      t.string:willing_to_travel
     # t.string:languages

      t.date:date_of_start
      t.timestamps
    end
  end
end
