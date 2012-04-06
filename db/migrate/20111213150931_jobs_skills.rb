class JobsSkills < ActiveRecord::Migration
  def self.up
    create_table :jobs_skills, :id => false do |t|
      t.references :job, :skill
    end
  end
  def self.down
    drop_table :jobs_skills
  end
end
