module Logistic

  class Function
    attr_accessor :mean
    attr_accessor :scale

    def initialize(mean, scale)
      @mean = mean
      @scale = scale
    end

    def apply(x)
      8 + 8.0 / (1+ Math.exp(@scale * (@mean - x)))
    end

    def error(data)
      sum = data.sum 0 do |age, body|
        (apply(age) - body) ** 2
        end
      sum / data.length
    end

  end

  class GradientDescent
    attr_accessor :data

    def initialize(data, mean, scale)
      @data = data
      @mean, @scale = next_mean_scale(mean, scale)
    end

    def results
      [@mean, @scale]
    end

    def next_mean_scale(mean, scale, d = 1.0)
      puts "mean #{mean}, scale #{scale}, d #{d}, error #{Function.new(mean, scale).error(@data)}"
      neighbors = [
          [mean+d, scale],
          [mean-d, scale],
          [mean, scale+d],
          [mean, scale-d],
      ]
      min_mean, min_scale = ([[mean, scale]] + neighbors).min_by{|m,s| Function.new(m,s).error(@data)}
      if min_mean == mean and min_scale == scale
        if d > 0.1
          next_mean_scale(mean, scale, d / 2)
        else
          [mean, scale]
        end
      else
        next_mean_scale(min_mean, min_scale, d)
      end
    end
  end

  class Data
    attr_accessor :data
    attr_accessor :function

    # @return Float
    def min
      self.data.min.first.to_i
    end

    # @return Float
    def max
      self.data.max.first.ceil
    end

    def xrange
      min..max
    end

    def initialize(data)
      self.data = data
      mean, scale = GradientDescent.new(self.data, 4.0, 4.0).results
      puts "mean #{mean}, scale #{scale}"
      self.function = Function.new(mean, scale)
    end

    def to_a
      xrange.map{|age| [age, self.function.apply(age)]}
    end
  end

end
