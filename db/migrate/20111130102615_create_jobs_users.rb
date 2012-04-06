class CreateJobsUsers < ActiveRecord::Migration
	def self.up
    create_table :jobs_users, :id => false do |t|
      t.references :job, :user
    end
  end
  def self.down
    drop_table :jobs_users
  end
end
