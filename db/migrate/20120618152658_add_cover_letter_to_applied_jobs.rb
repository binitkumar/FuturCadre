class AddCoverLetterToAppliedJobs < ActiveRecord::Migration
  def change
    add_column :applied_jobs, :cover_letter_id, :integer
  end
end
