class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :rateable, :polymorphic => true
      t.integer :rate

      t.timestamps
    end
  end
end
