module Day07
  class << self
    def result(part)
      hand_and_bid_lines = read_inputs(7).split("\n")
      case part
      when 1
        hand_and_bids = hand_and_bid_lines.map { |line| parse_hand_and_bid(line) }
        total_winnings(hand_and_bids)
      when 2
      end
    end

    CARD_VALUES = { 'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10 }.freeze

    def parse_hand_and_bid(line)
      cards_part, bid_string = line.split
      {
        hand: cards_part.chars.map { |card| CARD_VALUES[card] || card.to_i },
        bid: bid_string.to_i
      }
    end

    def hand_type(hand)
      group_sizes = same_card_group_sizes(hand)
      HAND_TYPES[group_sizes] || :high_card
    end

    def compare_hands(left, right)
      hand_type_comparison = HAND_TYPE_STRENGTH[hand_type(left)] <=> HAND_TYPE_STRENGTH[hand_type(right)]
      return hand_type_comparison unless hand_type_comparison.zero?

      left <=> right
    end

    def sort_hand_and_bids(hand_and_bids)
      hand_and_bids.sort { |left, right| compare_hands(left[:hand], right[:hand]) }
    end

    def total_winnings(hand_and_bids)
      sorted = sort_hand_and_bids(hand_and_bids)
      sorted.each_with_index.to_a.sum { |hand_and_bid, index|
        hand_and_bid[:bid] * (index + 1)
      }
    end

    private

    HAND_TYPES = {
      [5] => :five_of_a_kind,
      [1, 4] => :four_of_a_kind,
      [2, 3] => :full_house,
      [1, 1, 3] => :three_of_a_kind,
      [1, 2, 2] => :two_pair,
      [1, 1, 1, 2] => :one_pair
    }.freeze

    HAND_TYPE_STRENGTH = {
      five_of_a_kind: 6,
      four_of_a_kind: 5,
      full_house: 4,
      three_of_a_kind: 3,
      two_pair: 2,
      one_pair: 1,
      high_card: 0
    }.freeze

    def same_card_group_sizes(hand)
      hand.group_by(&:itself).values.map(&:size).sort
    end
  end
end
