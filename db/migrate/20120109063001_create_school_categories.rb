class CreateSchoolCategories < ActiveRecord::Migration
  def change
    create_table :school_categories do |t|
     t.string :name
     t.timestamps
    end
  end
end
