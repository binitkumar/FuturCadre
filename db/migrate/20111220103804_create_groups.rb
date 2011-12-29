class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.boolean :featured
      t.integer :owner_id
      t.timestamps
    end
  end
end
