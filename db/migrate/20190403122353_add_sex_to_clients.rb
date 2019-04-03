class AddSexToClients < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :sex, :string
  end
end
