class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.boolean :featured
      t.integer :owner_id
      t.integer :manager_id
      t.integer :mean_salary
      t.references :group_type
      t.timestamps
    end
  end
  def self.down
    drop_table :groups
  end
end
