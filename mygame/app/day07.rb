module Day07
  class << self
    def result(part)
      hand_and_bid_lines = read_inputs(7).split("\n")

      with_joker = part == 2
      hand_and_bids = hand_and_bid_lines.map { |line| parse_hand_and_bid(line, with_joker: with_joker) }
      total_winnings(hand_and_bids, with_joker: with_joker)
    end

    def parse_hand_and_bid(line, with_joker: false)
      cards_part, bid_string = line.split
      {
        hand: rules(with_joker).parse_hand(cards_part),
        bid: bid_string.to_i
      }
    end

    def hand_type(hand, with_joker: false)
      rules(with_joker).hand_type(hand)
    end

    def compare_hands(left, right, with_joker: false)
      rules = rules(with_joker)
      left_hand_type = rules.hand_type(left)
      right_hand_type = rules.hand_type(right)
      hand_type_comparison = HAND_TYPE_STRENGTH[left_hand_type] <=> HAND_TYPE_STRENGTH[right_hand_type]
      return hand_type_comparison unless hand_type_comparison.zero?

      left <=> right
    end

    def sort_hand_and_bids(hand_and_bids, with_joker: false)
      hand_and_bids.sort { |left, right| compare_hands(left[:hand], right[:hand], with_joker: with_joker) }
    end

    def total_winnings(hand_and_bids, with_joker: false)
      sorted = sort_hand_and_bids(hand_and_bids, with_joker: with_joker)
      sorted.each_with_index.to_a.sum { |hand_and_bid, index|
        hand_and_bid[:bid] * (index + 1)
      }
    end

    private

    HAND_TYPE_STRENGTH = {
      five_of_a_kind: 6,
      four_of_a_kind: 5,
      full_house: 4,
      three_of_a_kind: 3,
      two_pair: 2,
      one_pair: 1,
      high_card: 0
    }.freeze

    def rules(with_joker)
      with_joker ? WithJokerRules : DefaultRules
    end
  end

  class DefaultRules
    HAND_TYPES = {
      [5] => :five_of_a_kind,
      [1, 4] => :four_of_a_kind,
      [2, 3] => :full_house,
      [1, 1, 3] => :three_of_a_kind,
      [1, 2, 2] => :two_pair,
      [1, 1, 1, 2] => :one_pair
    }.freeze

    class << self
      def parse_hand(cards_string)
        cards_string.chars.map { |card| card_values[card] || card.to_i }
      end

      def hand_type(hand)
        group_sizes = card_counts(hand).values.sort
        HAND_TYPES[group_sizes] || :high_card
      end

      private

      def card_values
        @card_values ||= { 'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10 }.freeze
      end

      def card_counts(hand)
        hand.group_by(&:itself).transform_values(&:size)
      end
    end
  end

  class WithJokerRules < DefaultRules
    JOKER_VALUE = 1

    class << self
      def hand_type(hand)
        super(replace_jokers_with_most_frequent_card(hand))
      end

      private

      def card_values
        @card_values ||= super.merge('J' => JOKER_VALUE).freeze
      end

      def replace_jokers_with_most_frequent_card(hand)
        card_counts = card_counts(hand)
        return hand unless card_counts.key? JOKER_VALUE

        most_frequent_card = card_counts.keys.max_by { |card|
          next 0 if card == JOKER_VALUE # Skip Joker

          card_counts[card]
        }
        hand.map { |card| card == JOKER_VALUE ? most_frequent_card : card }
      end
    end
  end
end
