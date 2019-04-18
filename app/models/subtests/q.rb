module Subtests
  class Q < Subtest
    def vyhodnot_riadok(line)
      spravne = {'focus1' => 1, # WHITE cow
                 'focus2' => 2, # blue COW
                 'focus3' => 1, # BLUE sheep
                 'focus4' => 2, # white COW
                 'focus5' => 1, # BLACK sheep
                 'focus6' => 2, # white SHEEP
                 'focus7' => 1, # RED cow
                 'focus8' => 2, # red COW
                 'focus9' => 1, # WHITE sheep
                 'focus10' => 2, # red SHEEP
                 'focus11' => 1, # BLACK cow
                 'focus12' => 2, # blue SHEEP
                 'focus13' => 1, # RED sheep
                 'focus14' => 2, # black SHEEP
                 'focus15' => 1, # BLUE cow
                 'focus16' => 2} # black COW
      a = line[stlpec_client]
      bbb = line[stlpec_spravne]
      bb = /^L:([a-z]*\d*)\.bmp$/.match(bbb).captures.first
      b = case spravne[bb]
          when 1
            'l'
          when 2
            'r'
          end
      if a and b and a.last == b
        1
      else
        0
      end
    end
  end
end
