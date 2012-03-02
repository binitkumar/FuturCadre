class CreateProfessionInformations < ActiveRecord::Migration
  def change
    create_table :profession_informations do |t|
      t.integer :profile_id
      t.string :profession_industry
			t.string :profession_experience
			t.integer :category_id
      #t.string :career_level
			t.string :job_title
			t.string :company_name
			
      t.timestamps
    end
  end
end
