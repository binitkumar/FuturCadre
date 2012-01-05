class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.boolean :featured
      t.integer :owner_id
      t.integer :mean_salary
      t.references :group_type
      t.timestamps
    end
  end
end
