class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :user
      t.references :profile
      t.timestamps

    end
  end
end
