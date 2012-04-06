class CreateAppliedJobs < ActiveRecord::Migration
 def self.up
    create_table :applied_jobs do |t|
      t.references :user, :job
      t.integer  :cv_id
      t.timestamps
    end
 end
  def self.down
    drop_table :applied_jobs
  end
end
