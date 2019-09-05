module RodneCisloCalculations

  def self.included(klass)
    raise "Undefined rodne cislo when included #{self} from #{klass}" unless defined? :rodne_cislo
    # klass.validate :validate_rodne_cislo
  end

  def rok_narodenia_from_rodne_cislo
    return nil if rodne_cislo.blank?
    yy = rodne_cislo.first(2).to_i
    if yy > 30
      1900 + yy
    else
      2000 + yy
    end
  end

  def mesiac_narodenia_from_rodne_cislo
    return nil if rodne_cislo.blank?
    return 1 if rodne_cislo.size < 4
    mm = rodne_cislo.from(2).first(2).to_i
    if mm >= 50
      mm - 50
    else
      mm
    end
  end

  def den_narodenia_from_rodne_cislo
    return nil if rodne_cislo.blank?
    return 1 if rodne_cislo.size < 6
    rodne_cislo.from(4).first(2).to_i
  end

  def datum_narodenia_from_rodne_cislo
    Date.new(
        rok_narodenia_from_rodne_cislo,
        mesiac_narodenia_from_rodne_cislo,
        den_narodenia_from_rodne_cislo
    )
  end

  def validate_rodne_cislo
    return if rodne_cislo.blank?
    unless /\d\d/.match? rodne_cislo.first(2)
      errors.add(:rodne_cislo, 'Zlý formát rodného čísla na prvých dvoch pozíciach')
      return
    end
    unless /\d\d/.match? rodne_cislo.from(2).first(2)
      errors.add(:rodne_cislo, 'Zlý formát rodného čísla na tretej a štvrtej pozícii')
      return
    end
    unless /\d\d/.match? rodne_cislo.from(4).first(2)
      errors.add(:rodne_cislo, 'Zlý formát rodného čísla na piatej a šiestej pozícii')
      return
    end
    begin
      datum_narodenia = datum_narodenia_from_rodne_cislo
      if datum_narodenia.year >= 1954 # Do roku 1954 pridelovane 9 miestne RC nejde overit
        unless /\d{10}/.match? rodne_cislo
          errors.add(:rodne_cislo, 'Rodné číslo má mať 10 číslic')
          return
        end
        unless rodne_cislo.to_i % 11 == 0 or rodne_cislo.last == '0' # K niektorym RC pridali na koniec nulu
          errors.add(:rodne_cislo, "Rodné číslo (#{rodne_cislo}) má byť deliteľné 11 (zvyšok je #{rodne_cislo.to_i % 11})")
          return
        end
      else
        unless /\d{9,10}/.match? rodne_cislo
          errors.add(:rodne_cislo, 'Staré rodné číslo má mať 9 alebo 10 číslic')
          return
        end
      end
    rescue ArgumentError
      errors.add(:rodne_cislo, 'Nesprávny formát rodného čísla - nedá sa vypočítať dátum narodenia')
    end
  end

end
