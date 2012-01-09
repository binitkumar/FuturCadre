class CreateInstitutes < ActiveRecord::Migration
  def change
    create_table :institutes do |t|

      t.timestamps
      t.string :slug
      t.string :name
    end
  end
end
