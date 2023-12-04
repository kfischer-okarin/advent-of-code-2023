module Day04
  class << self
    def result(part)
      cards = read_inputs(4).split("\n").map { |card_string| parse_card(card_string) }
      case part
      when 1
        cards.sum { |card| points(card) }
      when 2
        matching_numbers_for_every_card = cards.map { |card| number_of_matches(card) }
        total_cards_after_copies(matching_numbers_for_every_card).sum
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
      matches = number_of_matches(card)
      return 0 if matches.zero?

      2**(matches - 1)
    end

    def total_cards_after_copies(matching_numbers_for_every_card)
      # In the beginning you have 1 card of each kind
      result = matching_numbers_for_every_card.map { 1 }
      (0...result.size).each do |card_index|
        matches = matching_numbers_for_every_card[card_index]
        ((card_index + 1)..(card_index + matches)).each do |copied_card_index|
          next if copied_card_index >= result.size

          result[copied_card_index] += result[card_index]
        end
      end
      result
    end

    private

    def number_of_matches(card)
      card[:own_numbers].select { |number| card[:winning_numbers][number] }.size
    end
  end
end
