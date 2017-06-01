class Card
  SUITS =      %w{hearts diamonds spades clubs}
  RANKS =   %w{ace    two three four five six seven eight nine ten  jack queen king}
  BLACKJACK = [[1,11],[2],[3],  [4], [5], [6],[7],  [8],  [9], [10],[10],[10], [10]]
  def initialize(suit,rank)
    @suit =  SUITS[suit]
    @rank =  RANKS[rank]
    @value = BLACKJACK[rank]
  end

  def to_s
    "#{@rank.capitalize} of #{@suit.capitalize}"
  end

  def value
    @value
  end

  # def ==(other) # May never be useful. Delete if so.
  #   self.value == other.value
  # end
  #
  # def >(other) # May never be useful. Delete if so.
  #   self.value > other.value
  # end
  #
  # def <(other) # May never be useful. Delete if so.
  #   self.value < other.value
  # end
end
