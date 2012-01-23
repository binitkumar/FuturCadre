class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.text :place
      t.datetime :time_of_start
      t.datetime :time_of_end
      t.timestamps
    end
  end
end
