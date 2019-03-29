class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :rodne_cislo
      t.string :folder
      t.string :meno
      t.string :priezvisko

      t.timestamps
    end
  end
end
