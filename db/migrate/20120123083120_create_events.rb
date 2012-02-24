class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :time_of_start
      t.string :time_of_end
      t.text :description
      t.string :place
      t.integer  :group_id
      t.integer  :user_id
      t.boolean  :is_approve
      t.timestamps
    end
  end
end
