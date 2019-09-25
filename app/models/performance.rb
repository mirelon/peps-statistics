class Performance < ApplicationRecord
  belongs_to :client
  belongs_to :subtest

  def to_f
    body
  end

  def pocet_mesiacov
    ((datum - client.datum_narodenia_from_rodne_cislo).to_f / 365 * 12).round
  end
end
