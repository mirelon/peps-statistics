class CreatePerformances < ActiveRecord::Migration[6.0]
  def change
    create_table :performances do |t|
      t.date :datum
      t.decimal :body
      t.references :client, foreign_key: true
      t.references :subtest, foreign_key: true

      t.timestamps
    end
  end
end
