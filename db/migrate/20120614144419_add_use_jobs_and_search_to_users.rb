class AddUseJobsAndSearchToUsers < ActiveRecord::Migration
  def change
    add_column :users, :used_jobs, :integer
    add_column :users, :used_searches, :integer
  end
end
