class CreateThesesUsers < ActiveRecord::Migration
 def self.up
    create_table :theses_users do |t|
      t.references :user, :thesis
      t.timestamps
    end
 end
  def self.down
    drop_table :theses_users
  end
end
