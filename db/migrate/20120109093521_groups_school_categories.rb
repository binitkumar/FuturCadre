class GroupsSchoolCategories < ActiveRecord::Migration
  def self.up
    create_table :groups_school_categories, :id => false do |t|
      t.references :group, :school_category
    end
  end
  def self.down
    drop_table :groups_school_categories
  end
end
