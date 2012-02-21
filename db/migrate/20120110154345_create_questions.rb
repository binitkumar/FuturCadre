class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
      t.text  :body
      t.references :question_category, :user , :group
      t.timestamps
    end
  end
end
