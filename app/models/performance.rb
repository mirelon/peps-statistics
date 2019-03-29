class Performance < ApplicationRecord
  belongs_to :client
  belongs_to :subtest
end
