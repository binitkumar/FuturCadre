class AddIsSavedToAppliedJobs < ActiveRecord::Migration
  def change
    add_column :applied_jobs, :is_saved, :boolean, :default => false
  end
end
