class CreateJobsUsers < ActiveRecord::Migration
	def change
    create_table :jobs_users, :id => false do |t|
      t.references :job, :user
    end
  end
end
