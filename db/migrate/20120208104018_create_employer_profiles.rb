class CreateEmployerProfiles < ActiveRecord::Migration
  def self.up
    create_table :employer_profiles do |t|
      t.references :profile
      t.integer  :employer_id
      t.string :employer_type
      t.boolean :is_deleted, :default => false
      t.timestamps
    end
  end
  def self.down
    drop_table :employer_profiles
  end
end
