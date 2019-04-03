class Subtest < ApplicationRecord
  has_many :performances
  self.inheritance_column = :pismeno
  self.store_full_sti_class = false

  # @return Integer Ziskane body
  def vyhodnot(file)
    table = CSV.parse(file, headers: false, col_sep: "\t")
    vyhodnot_riadky table.filter{|line| line.first.include? 'Item'}
  end

  def vyhodnot_riadky(lines)
    lines.sum{|line| vyhodnot_riadok(line)}
  end

  # @return Integer Ziskane body
  def vyhodnot_riadok(line)
    raise NotImplementedError
  end

  def data_for_scatter_chart
    performances.map do |p|
      {
          sex: p.client.sex,
          data: [p.client.age, p.body]
      }
    end.group_by{|p| p[:sex]}.map{|k,v| {name: k, data: v.map{|vv| vv[:data]}}}
  end

  protected
  # Used for creating class according to pismeno
  # Also for creating association proxy
  def self.compute_type(type_name)
    if type_name.== 'Performance'
      super(type_name)
    else
      super("Subtests::#{type_name}")
    end
  end
end
