class CreateSubtests < ActiveRecord::Migration[6.0]
  def change
    create_table :subtests do |t|
      t.string :pismeno
      t.string :popis
      t.string :filename
      t.integer :stlpec_spravne
      t.integer :stlpec_client

      t.timestamps
    end
  end
end
