class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.references :group, :user
      t.boolean :is_manager , :default =>false
      t.timestamps
    end
  end
end
