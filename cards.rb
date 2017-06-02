class Cards
  def initialize
    @cards = []
  end

  def shuffle
    @cards.shuffle!
    self
  end

  def draw
    @cards.pop
  end

  def size
    @cards.size
  end

  def [](index)
    @cards[index]
  end

  def <<(card)
    @cards << card if card.kind_of? Card
  end

  def ==(other_card)
    self.value == other_card.value
  end

  def to_s
    if @cards.size.zero?
      "Empty hand"
    else
      @cards.map { |card| card.to_s }.join(", ")
    end
  end
end

class Shoe < Cards
  def add_deck(number=1)
    number.times do
      (0..3).each do |suit|
        (0..12).each do |rank|
          @cards << Card.new(suit, rank)
        end
      end
    end
    self
  end
end

class Hand < Cards
  attr_accessor :bet
  attr_writer   :stand

  def initialize(*cards)
    @cards = cards
    @bet = 0
    @stand = false
  end

  def status
    if @cards.size.zero?
      :empty
    elsif value.min > 21
      :busted
    elsif (@cards[0].value + @cards[1].value).size == 3 &&
      value.include?(21)
        :blackjack
    elsif value.include? 21
      :twentyone
    elsif @stand
      :stand
    else
      :in_play
    end
  end

  def value
    aces = 0
    minvalue = @cards.reduce(0) do |total, card|
      aces += 1 if card.value.size == 2
      total += card.value[0]
    end
    values = []
    0.upto(aces) do |ace|
      values << (minvalue+10*ace)
    end
    values
  end
end
