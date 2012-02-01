class CreateThesesUsers < ActiveRecord::Migration
  def change
    create_table :theses_users do |t|
      t.references :user, :thesis
      t.timestamps
    end
  end
end
