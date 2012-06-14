class AddIsDownloadedToAppliedJobs < ActiveRecord::Migration
  def change
    add_column :applied_jobs, :is_downloaded, :boolean, :default => false
  end
end
