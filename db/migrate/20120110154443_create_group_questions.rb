class CreateGroupQuestions < ActiveRecord::Migration
  def change
    create_table :group_questions do |t|
      t.references :question, :group
      t.timestamps
    end
  end
end
