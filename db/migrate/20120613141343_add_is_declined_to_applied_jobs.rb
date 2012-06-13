class AddIsDeclinedToAppliedJobs < ActiveRecord::Migration
  def change
    add_column :applied_jobs, :is_declined, :boolean,:default => false
  end
end
