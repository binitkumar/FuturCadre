class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
      t.text  :body
      t.references :question_category
      t.timestamps
    end
  end
end
