module Subtests
  class P < Subtest
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
end
