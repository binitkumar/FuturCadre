class CreateProjectUsers < ActiveRecord::Migration
  def change
    create_table :project_users do |t|
       t.references :user, :project
      t.timestamps
    end
  end
end
