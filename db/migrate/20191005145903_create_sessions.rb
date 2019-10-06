class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.date :datum
      t.references :client, null: false, foreign_key: true
      t.integer :months

      t.timestamps
    end

    add_reference :performances, :session, foreign_key: true

    Client.all.each do |client|
      performance = client.performances.first
      if performance
        session = client.sessions.create!(datum: performance.datum, months: performance.pocet_mesiacov)
        client.performances.each do |p|
          p.update! session: session
        end
      end
    end

    remove_reference :performances, :client
  end
end
