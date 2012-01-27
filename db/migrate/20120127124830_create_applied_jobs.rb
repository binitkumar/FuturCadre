class CreateAppliedJobs < ActiveRecord::Migration
  def change
    create_table :applied_jobs do |t|
      t.references :user, :job
      t.integer  :cv_id
      t.timestamps
    end
  end
end
