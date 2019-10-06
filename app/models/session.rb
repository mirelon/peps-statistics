class Session < ApplicationRecord
  belongs_to :client
  has_many :performances, dependent: :destroy
end
