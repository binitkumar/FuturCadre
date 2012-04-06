class CreateGroupUsers < ActiveRecord::Migration
  def self.up
    create_table :group_users do |t|
      t.references :group, :user
      t.boolean :is_manager , :default =>false
      t.timestamps
    end
  end
  def self.down
    drop_table :group_users
  end
end
