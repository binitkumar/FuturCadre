class AddSkillsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :skills, :string
  end
end
