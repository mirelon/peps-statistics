module Subtests
  class G < Subtest
    def vyhodnot_riadok(line)
      spravne_slova = {'book1' => 'cream.',
                       'book2' => 'cream?',
                       'book3' => 'cabbage.',
                       'book4' => 'cabbage?',
                       'book5' => 'honey.',
                       'book6' => 'honey?',
                       'book7' => 'leeks.',
                       'book8' => 'leeks?',
                       'plate1' => 'apple.',
                       'plate2' => 'apple?',
                       'plate3' => 'cake.',
                       'plate4' => 'cake?',
                       'plate5' => 'cheese.',
                       'plate6' => 'cheese?',
                       'plate7' => 'jam.',
                       'plate8' => 'jam?'}
      a = line[stlpec_client]
      bbb = line[stlpec_spravne]
      bb = /^L:([a-z]*\d*)\.bmp$/.match(bbb).captures.first
      b = case spravne_slova[bb].last
          when '.'
            'u'
          when '?'
            'h'
          end
      if a and b and a.last == b.last
        1
      else
        0
      end
    end
  end
end
