class Performance < ApplicationRecord
  belongs_to :session
  delegate :client, to: :session
  belongs_to :subtest

  def to_f
    body
  end

  def pocet_mesiacov
    ((datum - client.datum_narodenia_from_rodne_cislo).to_f / 365 * 12).round
  end

  def years
    session.months / 12
  end

  def years_f
    session.months / 12.0
  end
end
