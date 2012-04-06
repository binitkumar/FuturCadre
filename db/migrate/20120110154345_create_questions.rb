class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string :name
      t.text  :body
      t.references :question_category, :user , :group
      t.timestamps
    end
  end
  def self.down
    drop_table :questions
  end
end
