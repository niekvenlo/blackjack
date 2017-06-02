# BLACKJACK
require_relative 'cards.rb'
require_relative 'card.rb'

class Player
  @@total_players = 0
  attr_reader :id, :cash

  def initialize(shoe)
    @@total_players += 1
    @id = @@total_players
    @cash = 100
    @hands = [Hand.new]
    @shoe = shoe
  end

  def hands
    @hands
  end

  def total_bets
    @hands.reduce(0) { |sum, hand| sum += hand.bet }
  end

  def <<(hand)
    @hands << hand
  end

  def each(&block)
    @hands.each(&block)
  end

  def can_double?
     @cash > total_bets
  end

  def can_split?(hand)
    hand.size == 2 && hand[0] == hand[1] && @hands.size < 2 && can_double?
  end

  def can_bet?(bet=0)
    @cash-bet > 0
  end

  def to_s
    str_bld = "#{self.class.to_s.capitalize} #{@id}:\n$#{@cash} in cash"
    str_bld << " and a $#{total_bets} bet" unless total_bets.zero?
    str_bld << ".\n\n"
    if @hands.size.zero?
      str_bld << "No cards"
    else
      str_bld << @hands.map(&:to_s).join("\n")
    end
    str_bld << "\n"
  end

  def bet
    if can_bet?
      puts "Player #{@id}, you have $#{@cash}. How much would you like to bet?"
      bet = gets.chomp.to_i
      bet = @cash if bet > @cash
      @cash -= bet
      @hands[0].bet = bet
    else
      puts "Player #{@id} is out of the game."
    end
  end

  def choose(hand)
    return false unless hand.status == :in_play
    puts "\n"*3
    puts self
    if can_split?(hand)
      puts "(h)it, (s)tand, (d)ouble, or s(p)lit"
    else
      puts "(h)it, (s)tand, or (d)ouble"
    end
    case gets.chomp
    when "h", "hit" then hit(hand)
    when "s", "stand" then stand(hand)
    when "d", "double" then double(hand)
    when "p", "split" then split(hand)
    else "Try again"
    end
  end

  def hit(hand)
    hand << @shoe.draw
  end

  def stand(hand)
    hand.stand = true
  end

  def double(hand)
    if can_double?
      bet = hand.bet
      @cash -= bet
      hand.bet *= 2
    end
  end

  def split(hand)
    if !can_split?(hand)
      choose
    else
      @hands << Hand.new(hand.draw, @shoe.draw)
      hand << @shoe.draw
      bet = total_bets
      @cash -= bet
      @hands.each { |hand| hand.bet = bet }
    end
  end
end

puts "BLACKJACK".center(20, "=")
shoe = Shoe.new.add_deck.shuffle
player =  Player.new(shoe)
player.bet
flee = shoe.draw
player.hands[0] << flee#shoe.draw
player.hands[0] << flee
while player.choose(player.hands[0])
  puts player.hands[0].status
end
if player.hands.size > 1
  while player.choose(player.hands[1])
    puts player.hands[1].status
  end
end

p player.hands[0].value
puts "good enough" if player.hands[0].value.min <= 21
puts "___"
# p player

# puts "BLACKJACK".center(20, "=")
# shoe = Shoe.new.add_deck.shuffle
# players = []
# puts "How many players?"
# num = gets.chomp.to_i.times do
#   players << Player.new(shoe)
# end
# # flee = shoe.draw
# puts players
# players.each { |player| player.bet }
# players.each do |player|
#   player.hands[0] << shoe.draw
#   player.hands[0] << shoe.draw
# end
# puts players
# players.each { |player| player.choose }
# puts players





str = <<BOBB
What do I want?
Players basically take turns, don't they?
- Each player plays his hands until he is done
- Each hand has a value, to be compared later.
- (No need for a status to be stored)
- Then the other players play until they are done
- The dealer plays until they are done too.
- The values of all hands are compared
- Any hands that beat the dealer, get payout

- Do I need a status to mark :stand?

How many players?
>> 1
[Create player objects]
How much do you want to bet?
>> 21
[Assign bet to empty player hand, adjust player cash]
Player, $79 in cash and a $21 bet.
[Deal cards into the empty hand]
Your hand:
Ten of Clubs, Ten of Hearts
What do you want to do?
(h)it, (s)tand, (d)ouble, s(p)lit
>> p
[Create new hand, divide first hand cards and draw new card for each hand]
BOBB
