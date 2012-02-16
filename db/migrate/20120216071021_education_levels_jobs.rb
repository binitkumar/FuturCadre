class EducationLevelsJobs < ActiveRecord::Migration
  def change
    create_table :education_levels_jobs, :id => false do |t|
      t.references :job, :education_level
    end
  end
end
