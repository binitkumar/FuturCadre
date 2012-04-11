class CreateEducationInformations < ActiveRecord::Migration
  #def up
  def self.up
    create_table :education_informations do |t|
      t.references :institute
      t.integer :profile_id
      t.string :degree_level
      t.string :major_subject
      t.string :institute_name
      t.datetime :start_date
      t.datetime :end_date

      #t.string :institute
      #t.text :year
      t.timestamps
    end
  end
      def self.down
   drop_table :education_informations
  end
end
