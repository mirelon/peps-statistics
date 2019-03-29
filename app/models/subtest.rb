class Subtest < ApplicationRecord
  has_many :performances
  self.inheritance_column = :pismeno

  # @return Integer Ziskane body
  def vyhodnot(file)
    table = CSV.parse(file, headers: false, col_sep: "\t")
    table.filter{|line| line.first.include? 'Item'}.sum{|line| vyhodnot_riadok(line)}
  end

  # @return Integer Ziskane body
  def vyhodnot_riadok(line)
    raise NotImplementedError
  end
end

class I < Subtest
  def vyhodnot_riadok(line)
    a = line[3]
    b = line[8]
    if a and b and ((a.last == 'i' and b.last == 'L') or (a.last == '_' and b.last == 'R'))
      1
    else
      0
    end
  end
end

class H < Subtest
  def vyhodnot_riadok(line)
    a = line[stlpec_client]
    b = line[stlpec_spravne]
    if a and b and a.last == b.last
      1
    else
      0
    end
  end
end
