class GroupsJobs < ActiveRecord::Migration
  def self.up
      create_table :groups_jobs, :id => false do |t|
        t.references :group, :job
      end
  end
  def self.down
    drop_table :groups_jobs
  end

end
