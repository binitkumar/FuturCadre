class AddEmployerIdToAppliedJobs < ActiveRecord::Migration
  def change
    add_column :applied_jobs, :employer_id, :integer
  end
end
