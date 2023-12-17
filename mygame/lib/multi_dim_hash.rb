class MultiDimHash
  def initialize(initial_values = nil)
    @hash = {}
    return unless initial_values

    initial_values.each do |key, value|
      self[key] = value
    end
  end

  def []=(keys, value)
    hash = @hash
    keys[0..-2].each do |key|
      hash = hash[key] ||= {}
    end
    hash[keys[-1]] = value
  end

  def [](keys)
    value = @hash
    keys.each do |key|
      value ||= {}
      value = value[key]
    end
    value
  end
end
