class CreateProfessionInformations < ActiveRecord::Migration
  #def up
def self.up
    create_table :profession_informations do |t|
      t.integer :profile_id
      t.string :profession_industry
      t.string :profession_experience
      #t.integer :category_id
      #t.integer :sector_id
      #t.string :career_level
      t.string :job_title
      t.string :company_name
      t.datetime :start_date
      t.datetime :end_date
      t.references :category, :sector
      t.timestamps
    end
end
  def self.down
    drop_table :profession_informations
  end
end