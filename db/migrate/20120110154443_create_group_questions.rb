class CreateGroupQuestions < ActiveRecord::Migration
  def self.up
    create_table :group_questions do |t|
      t.references :question, :group
      t.timestamps
    end
  end
  def self.down
    drop_table :group_questions
  end
end
