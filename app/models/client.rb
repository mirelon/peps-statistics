class Client < ApplicationRecord
  has_many :performances

  def display_name
    "#{meno} #{priezvisko}"
  end
end
