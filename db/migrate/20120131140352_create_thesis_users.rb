class CreateThesisUsers < ActiveRecord::Migration
  def change
    create_table :thesis_users do |t|
      t.references :user, :thesis
      t.timestamps
    end
  end
end
