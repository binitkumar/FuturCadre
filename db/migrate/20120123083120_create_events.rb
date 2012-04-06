class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.datetime :time_of_start
      t.datetime :time_of_end
      t.text :description
      t.string :place
      t.integer  :group_id
      t.integer  :user_id
      t.boolean  :is_approve , :default => false
      t.timestamps
    end
  end
  def self.down
    drop_table :events
  end
end
