module Day06
  class << self
    def result(part)
      races_string = read_inputs(6)
      case part
      when 1
        races = parse_races(races_string)
        winning_charge_times_per_race = races.map { |race| winning_charge_times(race) }
        winning_charge_times_per_race.map(&:length).inject(:*)
      when 2
        race = parse_race(races_string)
        winning_charge_times(race).size
      end
    end

    def parse_races(races_string)
      time_line, distance_line = races_string.split("\n")
      times = parse_numbers(time_line)
      distances = parse_numbers(distance_line)
      times.map_with_index { |time, index|
        { time: time, distance: distances[index] }
      }
    end

    def parse_race(races_string)
      time_line, distance_line = races_string.split("\n")
      times = parse_numbers(time_line)
      distances = parse_numbers(distance_line)
      {
        time: times.map(&:to_s).join.to_i,
        distance: distances.map(&:to_s).join.to_i
      }
    end

    def winning_charge_times(race)
      time = race[:time]
      distance = race[:distance]
      (1..(time - 1)).select { |charge_time|
        move_time = time - charge_time
        move_time * charge_time > distance
      }
    end

    private

    def parse_numbers(line)
      _, numbers_part = line.split(':')
      numbers_part.split.map(&:to_i)
    end
  end
end
