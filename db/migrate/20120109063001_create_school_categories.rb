class CreateSchoolCategories < ActiveRecord::Migration
 def self.up
    create_table :school_categories do |t|
     t.string :name
     t.timestamps
    end
 end
  def self.down
    drop_table :school_categories
  end
end
