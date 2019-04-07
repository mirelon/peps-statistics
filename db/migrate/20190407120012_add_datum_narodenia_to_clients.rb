class AddDatumNarodeniaToClients < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :datum_narodenia, :date
  end
end
