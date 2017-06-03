class PlayingEntity
  attr_reader :id, :cash, :hand, :pot

  def initialize(shoe)
    @cash = 100
    @pot = 0
    @hand = Hand.new
    @shoe = shoe
  end

  def each(&block)
    @hands.each(&block)
  end

  def can_double?
     @cash > @pot
  end

  def can_bet?(new_bet=0)
    @cash-new_bet > 0
  end

  def to_s
    str_bld = "#{self.class.to_s.capitalize}:\n$#{@cash} in cash"
    str_bld << " and a $#{@bet} bet" unless @bet.zero?
    str_bld << ".\n\n"
    if @hand.size.zero?
      str_bld << "No cards"
    else
      str_bld << @hand.to_s
    end
    str_bld << "\n"
  end

  def bet
    puts "Player, you have $#{@cash}. How much would you like to bet?"
    new_bet = gets.chomp.to_i
    new_bet = @cash if new_bet > @cash
    @pot   = new_bet
    @cash -= new_bet
  end

  def hit(hand)
    hand << @shoe.draw
  end

  def stand(hand)
    hand.stand = true
  end

  def next_round
    @hand = Hand.new
  end
end

class Player < PlayingEntity
  def choose(hand)
    Paint.state
    return false unless hand.status == :in_play
    puts "(h)it, (s)tand, or (d)ouble"
    case gets.chomp
    when "h", "hit" then hit(hand)
    when "s", "stand" then stand(hand)
    when "d", "double" then double(hand)
    else "Try again"
    end
  end

  def double(hand)
    if can_double?
      @cash -= @bet
      @bet *= 2
    end
  end

  def win(payout)
    @cash += @pot*payout
    @pot = 0
  end

  def continue_playing
    true
  end
end

class Dealer < PlayingEntity
  def choose(hand)
    Paint.state
    sleep(2)
    return false unless hand.status == :in_play
    if hand.value.min < 17
      hit(hand)
    else
      stand(hand)
    end
  end
end
