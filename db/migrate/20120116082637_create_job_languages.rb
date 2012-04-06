class CreateJobLanguages < ActiveRecord::Migration
  def self.up
    create_table :job_languages do |t|
      t.references :job,:language
      t.integer :level_id
      t.string :level
      t.timestamps
    end
  end
  def self.down
    drop_table :job_languages
  end
end
