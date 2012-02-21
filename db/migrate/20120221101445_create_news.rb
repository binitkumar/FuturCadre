class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.references :user
      t.string :title
      t.text :body
      t.boolean :is_approved , :default => false

      t.timestamps
    end
  end
end
