require 'benchmark'

def image src
  File.open src
end

module Procedure
  NUMBER = 10

  class << self
    def run processor, img
      result = nil

      capture_stdout do
        result = Benchmark.bmbm do |b|
          (1..5).each do |number|
            b.report number do
              NUMBER.times do
                u = User.new :name => 'first'
                u.send :"#{processor}_avatar=", img
                u.save!
              end
            end
          end
        end
      end

      output result
    end

    def output result
      result = (result.map(&:to_a).map{|el| el[5]}.min * 1000).to_i
      puts "#{result}ms"
    end
  end
end
