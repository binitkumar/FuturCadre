class CreateProjectSkills < ActiveRecord::Migration
  def change
    create_table :project_skills do |t|

      t.timestamps
    end
  end
end
