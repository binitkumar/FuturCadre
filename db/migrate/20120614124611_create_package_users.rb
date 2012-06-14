class CreatePackageUsers < ActiveRecord::Migration
  def change
    create_table :package_users do |t|
      t.references :user, :package
      t.timestamps
    end
  end
end
