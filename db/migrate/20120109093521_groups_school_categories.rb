class GroupsSchoolCategories < ActiveRecord::Migration
  def change
    create_table :groups_school_categories, :id => false do |t|
      t.references :group, :school_category
    end
  end
end
