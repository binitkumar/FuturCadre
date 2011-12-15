class CreateResponsibilities < ActiveRecord::Migration
  def change
    create_table :responsibilities do |t|
      t.string  :name
      #t.string  :description

      t.timestamps
    end
  end
end
