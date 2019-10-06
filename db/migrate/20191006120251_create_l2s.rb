class CreateL2s < ActiveRecord::Migration[6.0]
  def change
    create_table :l2s do |t|
      t.string :nazov, null: false, default: ''

      t.timestamps
    end

    add_reference :clients, :l2, foreign_key: true

    l2 = L2.create nazov: ''
    %w(Zemplínčina Šariština Abovština Rómčina Rusínčina Ukrajinčina Maďarčina Rusnáčtina Spišština Záhoračtina Čeština Polština).each do |l2nazov|
      L2.create nazov: l2nazov
    end
    Client.all.each do |client|
      client.update l2: l2
    end
  end
end
