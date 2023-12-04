module Day04
  class << self
    def result(part)
      case part
      when 1
        cards = read_inputs(4).split("\n").map { |card_string| parse_card(card_string) }
        cards.sum { |card| points(card) }
      end
    end

    def parse_card(card_string)
      _, numbers_part = card_string.split(':').map(&:strip)
      winning_numbers_part, own_numbers_part = numbers_part.split('|').map(&:strip)
      result = {
        winning_numbers: {},
        own_numbers: own_numbers_part.split(' ').map(&:to_i)
      }
      winning_numbers_part.split(' ').each do |winning_number_string|
        result[:winning_numbers][winning_number_string.to_i] = true
      end
      result
    end

    def points(card)
      matching_numbers = card[:own_numbers].select { |number| card[:winning_numbers][number] }
      return 0 if matching_numbers.empty?

      2**(matching_numbers.size - 1)
    end
  end
end
