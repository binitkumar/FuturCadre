class EducationLevelsJobs < ActiveRecord::Migration
 def self.up
    create_table :education_levels_jobs, :id => false do |t|
      t.references :job, :education_level
    end
 end
  def self.down
    drop_table:education_levels_jobs
  end
end
