class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :time_of_start
      t.datetime :time_of_end
      t.text :description
      t.string :place
      t.integer  :group_id
      t.integer  :user_id
      t.boolean  :is_approve
      t.timestamps
    end
  end
end
