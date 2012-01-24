class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :name
      t.references :imageable, :polymorphic => true
      t.string :content_type
      t.timestamps
    end
  end
end
