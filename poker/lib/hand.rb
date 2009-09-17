require_relative './card.rb'
require_relative './ranking.rb'

class Hand
  attr_reader :cards

  def initialize(hand_string)
    @cards = []
    hand_string.split(" ").each do |card|
      @cards << Card.new(card)
    end
    @face_frequencies = face_frequencies
    @suit_frequencies = suit_frequencies
  end

  def score
    return Ranking::POKER if contains_poker?
    return Ranking::FULL_HOUSE if contains_full_house?
    return Ranking::FLUSH if contains_flush?
    return Ranking::STRAIGHT if contains_straight?
    return Ranking::THREE_OF_A_KIND  if contains_three_of_a_kind?
    return Ranking::TWO_PAIR if contains_two_pairs?
    return Ranking::PAIR if contains_pair?
    return Ranking::HIGH_CARD
  end

  private

    def face_frequencies
      frequencies = Hash.new
      @cards.each do |card|
        face = card.face
        if frequencies.include? face
          frequencies[face] += 1
        else
          frequencies[face] = 1
        end
      end
      return frequencies
    end

    def suit_frequencies
      frequencies = Hash.new
      @cards.each do |card|
        suit = card.suit
        if frequencies.include? suit
          frequencies[suit] += 1
        else
          frequencies[suit] = 1
        end
      end
      return frequencies
    end

    def contains_pair?
      tuples_with_length(2) > 0
    end

    def contains_two_pairs?
      tuples_with_length(2) > 1
    end

    def contains_three_of_a_kind?
      tuples_with_length(3) > 0
    end

    def contains_flush?
      @suit_frequencies.values.include? 5
    end

    def contains_full_house?
      contains_pair? and contains_three_of_a_kind? 
    end

    def contains_poker?
      tuples_with_length(4) > 0
    end

    def tuples_with_length(length)
      @face_frequencies.values.find_all { |l| l == length }.size 
    end

    FACES = ["1","2","3","4","5","6","7","8","9","T","J","Q","K","A"]

    LENGTH_OF_STRAIGHT = 5

    def contains_straight?
      (FACES.length-LENGTH_OF_STRAIGHT).downto(0) do |index|
        return true if contains_straight_starting_at index
      end
      return false
    end

    def contains_straight_starting_at(start)
      contains_straight = true
      faces = @cards.map { |card| card.face }
      (start...start+LENGTH_OF_STRAIGHT).each do |index|
        contains_straight = contains_straight && faces.include?(FACES[index])
      end
      return contains_straight
    end

end
