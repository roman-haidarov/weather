class CreateScores < ActiveRecord::Migration[6.1]
  def change
    create_table :scores do |t|
      t.string :timestamp, null: false
      t.string :unit, null: false
      t.float :value, null: false
    end
  end
end
