class L2 < ApplicationRecord
  has_many :clients

  def display_name
    nazov
  end
end
