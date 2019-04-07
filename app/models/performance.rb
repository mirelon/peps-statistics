class Performance < ApplicationRecord
  belongs_to :client
  belongs_to :subtest

  def to_f
    body
  end
end
