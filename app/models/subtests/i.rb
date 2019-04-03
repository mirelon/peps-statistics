module Subtests
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
end
