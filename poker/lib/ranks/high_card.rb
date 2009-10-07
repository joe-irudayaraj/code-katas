class HighCard < Rank
  def initialize(face)
    @face = face
    super("High Card")
  end

  def self.find_in(hand)
    highest_card = hand.cards.sort.last
    HighCard.new(highest_card.face)
  end

  def ==(other)
    other.instance_of? HighCard
  end

  def value
    @face.value
  end
end