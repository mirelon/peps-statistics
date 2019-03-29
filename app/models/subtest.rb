class Subtest < ApplicationRecord
  has_many :performances

  # @return Integer Ziskane body
  def vyhodnot(file)
    if pismeno == 'I'
      table = CSV.parse(file, headers: false, col_sep: "\t")
      table.filter{|line| line.first.include? 'Item'}.sum do |line|
        a = line[3]
        b = line[8]
        if a and b and ((a.last == 'i' and b.last == 'L') or (a.last == '_' and b.last == 'R'))
          1
        else
          0
        end
      end
    end
  end
end
