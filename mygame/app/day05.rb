module Day05
  class << self
    def result(part)
      parts = read_inputs(5).split("\n\n")
      seeds_line = parts.shift
      maps = parts.map { |mapping_string| parse_mappings(mapping_string) }

      case part
      when 1
        seeds = parse_seeds(seeds_line)
        result = seeds
        maps.each do |map|
          result = result.map { |number| map_number(map, number) }
        end
        result.min
      when 2
        seed_ranges = parse_seed_ranges(seeds_line)
        result = seed_ranges
        maps.each do |map|
          result = result.flat_map { |range| map_range(map, range) }
        end
        result.min_by(&:begin).begin
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

    def parse_seed_ranges(seed_line)
      seeds = parse_seeds(seed_line)
      seeds.each_slice(2).map { |start, length| (start...(start + length)) }
    end

    def check_overlap(range, overlapping_range)
      begins_before = range.begin < overlapping_range.begin
      ends_before = range.end <= overlapping_range.begin
      begins_after = range.begin >= overlapping_range.end
      ends_after = range.end > overlapping_range.end

      if (begins_before && ends_before) || (begins_after && ends_after)
        return {
          overlapping: nil,
          non_overlapping: [range]
        }
      end

      if (!begins_before && !ends_after)
        return {
          overlapping: range,
          non_overlapping: []
        }
      end

      if (begins_before && ends_after)
        return {
          overlapping: overlapping_range,
          non_overlapping: [(range.begin...overlapping_range.begin), (overlapping_range.end...range.end)]
        }
      end

      if begins_before
        {
          overlapping: (overlapping_range.begin...range.end),
          non_overlapping: [(range.begin...overlapping_range.begin)]
        }
      else
        {
          overlapping: (range.begin...overlapping_range.end),
          non_overlapping: [(overlapping_range.end...range.end)]
        }
      end
    end

    def map_range(mappings, range)
      unmapped_ranges = [range]
      result = []
      until unmapped_ranges.empty?
        unmapped_range = unmapped_ranges.shift
        overlap = nil
        applicable_mapping = mappings.find { |mapping|
          overlap = check_overlap(unmapped_range, mapping[:from_range])
          overlap[:overlapping]
        }

        if applicable_mapping
          range = overlap[:overlapping]
          offset = applicable_mapping[:offset]
          result << ((range.begin + offset)...(range.end + offset))
          unmapped_ranges.concat overlap[:non_overlapping]
        else
          result << unmapped_range
        end
      end
      result
    end
  end
end
