class CreateProjectSkills < ActiveRecord::Migration
 def self.up
    create_table :project_skills do |t|

      t.timestamps
    end
 end
  def self.down
    drop_table :project_skills
  end
end
