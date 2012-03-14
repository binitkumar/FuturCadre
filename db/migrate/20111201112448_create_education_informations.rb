class CreateEducationInformations < ActiveRecord::Migration
  def up
    create_table :education_informations do |t|
      t.references :institute
      t.integer :profile_id
      t.string :degree_level
      t.string :major_subject
      t.date:start_date
      t.date:end_date
      #t.string :institute
      t.text :year
      t.timestamps
    end
  end
  def down
    drop_table :education_informations
  end
end
