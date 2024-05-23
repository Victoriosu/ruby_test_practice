class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :text
      t.string :test_type
      t.date :parse_date

      t.timestamps
    end
  end
end
