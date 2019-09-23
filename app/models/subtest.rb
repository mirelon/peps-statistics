class Subtest < ApplicationRecord
  has_many :performances, dependent: :destroy
  self.inheritance_column = :pismeno
  self.store_full_sti_class = false

  # @return Integer Ziskane body
  def vyhodnot(file)
    table = CSV.parse(file, headers: false, col_sep: "\t")
    vyhodnot_riadky table.filter{|line| line.first.include? 'Item'}
  end

  def vyhodnot_riadky(lines)
    lines.sum 0 do |line|
      vyhodnot_riadok(line)
    end
  end

  # @return Integer Ziskane body
  def vyhodnot_riadok(line)
    raise NotImplementedError
  end

  def data_for_scatter_chart
    performances.map do |p|
      {
          sex: p.client.sex,
          data: [p.client.age_f, p.body]
      }
    end.group_by{|p| p[:sex]}.map{|k,v| {name: k, data: v.map{|vv| vv[:data]}}}
  end

  # Combines real data with regression line
  def data_for_combo_chart
    [{
         name: 'Aproximácia',
         data: logistic_data.xrange.step(0.1).map do |x|
           [x, function.apply(x)]
         end}, {
         name: 'Výkony',
         data: performances.map do |p|
           [p.client.age_f(p.datum), p.body]
         end}]
  end

  attribute :function
  attribute :logistic_data

  def calculate_logistic
    data = performances.map do |p|
      [p.client.age_f, p.body]
    end
    self.logistic_data = Logistic::Data.new(data)
    self.function = self.logistic_data.function
  end

  def data_for_line_chart
    self.logistic_data.to_a

    # by sex
    # data_for_scatter_chart.map do |s|
    #   {name: "Fit #{s[:name]}", data: Logistic::Data.new(s[:data]).to_a}
    # end
  end

  def statistics_summary(age)
    performances_with_age = performances.filter{|p| p.client.age(p.datum) == age}
    count = performances_with_age.count
    sum = performances_with_age.sum(&:body)
    if count > 0
      mean = sum / count
      performances_with_age.sum{|p| (p.body - mean) ** 2}
    else

    end
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
