module Day05
  class << self
    def result(part)
      parts = read_inputs(5).split("\n\n")
      seeds = parse_seeds(parts.shift)
      maps = parts.map { |mapping_string| parse_mappings(mapping_string) }

      case part
      when 1
        result = seeds
        maps.each do |map|
          result = result.map { |number| map_number(map, number) }
        end
        result.min
      when 2
      end
    end

    def parse_seeds(seed_line)
      _, numbers_part = seed_line.split(':')
      numbers_part.strip.split(' ').map(&:to_i)
    end

    def parse_mappings(map_string)
      lines = map_string.split("\n")
      lines.shift # Remove title
      lines.map { |line|
        destination, source, length = line.split(' ').map(&:to_i)
        {
          from_range: (source...(source + length)),
          offset: destination - source
        }
      }
    end

    def map_number(mappings, number)
      applying_mapping = mappings.find { |mapping| mapping[:from_range].include? number }
      return number unless applying_mapping

      number + applying_mapping[:offset]
    end
  end
end
