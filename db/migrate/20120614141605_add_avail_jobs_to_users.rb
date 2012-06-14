class AddAvailJobsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avail_jobs, :integer
  end
end
