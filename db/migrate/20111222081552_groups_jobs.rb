class GroupsJobs < ActiveRecord::Migration
  def change
      create_table :groups_jobs, :id => false do |t|
        t.references :group, :job
      end
      end

end
