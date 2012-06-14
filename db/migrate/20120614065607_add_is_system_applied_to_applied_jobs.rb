class AddIsSystemAppliedToAppliedJobs < ActiveRecord::Migration
  def change
    add_column :applied_jobs, :is_system_applied, :boolean, :default => false
  end
end
