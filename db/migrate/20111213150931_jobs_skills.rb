class JobsSkills < ActiveRecord::Migration
  def change
    create_table :jobs_skills, :id => false do |t|
      t.references :job, :skill
    end
    end
end
