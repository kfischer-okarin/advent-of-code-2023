module Math
  class << self
    def prime_numbers_until(n)
      result = (2..n).to_a
      current = 0
      while current < result.size
        result = result.reject do |k|
          k != result[current] && (k % result[current]).zero?
        end
        current += 1
      end
      result
    end

    def prime_factors(number, prime_numbers: prime_numbers_until(number))
      result = []
      remain = number
      prime_numbers.each do |p|
        break if p > remain

        while (remain % p).zero?
          remain = remain.idiv(p)
          result << p
        end
      end
      result
    end

    def least_common_multiple(*numbers)
      prime_numbers = prime_numbers_until(numbers.max)
      factors = numbers.map { |k| prime_factors(k, prime_numbers: prime_numbers) }
      result = 1
      until factors.all?(&:empty?)
        factor = factors.map(&:first).compact.min
        max_count = factors.map { |f| f.count { |k| k == factor } }.max
        result *= factor**max_count
        factors.each { |f| f.delete factor }
      end
      result
    end
  end
end
