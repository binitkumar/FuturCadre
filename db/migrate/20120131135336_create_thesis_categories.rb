class CreateThesisCategories < ActiveRecord::Migration
  def change
    create_table :thesis_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
