class Client < ApplicationRecord
  has_many :performances
  include RodneCisloCalculations

  def display_name
    "#{meno} #{priezvisko}"
  end

  def age(date = Date.current)
    birthdate = datum_narodenia_from_rodne_cislo
    diff = date.year - birthdate.year
    (birthdate + diff.years > date) ? (diff - 1) : diff
  end
end
