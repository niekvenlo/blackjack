# BLACKJACK
require_relative 'cards.rb'
require_relative 'card.rb'

class Player
  @@total_players = 0
  attr_reader :cash

  def initialize(shoe)
    @@total_players += 1
    @cash = 100
    @hands = []
    @player_id = @@total_players
    @bet = 0
    @shoe = shoe
  end

  def id
    @player_id
  end

  def [](index)
      @hands[index]
    end

  def <<(hand)
    @hands << hand
  end

  def each(&block)
    @hands.each(&block)
  end

  def can_split?(hand)
    @hands.size < 2 && hand[0] == hand[1]
  end

  def can_bet?(bet=0)
    @cash-bet > 0
  end

  def to_s
    str_bld = "#{self.class.to_s.capitalize} #{@player_id}:\n$#{@cash} in cash"
    str_bld << " and a $#{@bet} bet" unless @bet.zero?
    str_bld << ".\n"
    if @hands.size.zero?
      str_bld << "No cards"
    else
      str_bld << @hands.map { |hand| hand.to_s }.join("\n")
    end
    str_bld << "\n\n"
    str_bld
  end

  def bet
    if can_bet?
      puts "Player #{@player_id}, you have $#{@cash}. How much would you like to bet?"
      @bet = gets.chomp.to_i
      @bet = @cash if @bet > @cash
      @cash -= @bet
    else
      puts "Player #{@player_id} is out of the game."
    end
  end

  def choose
    size = @hands.size
    idx = 0
    while idx < size
      hand = @hands[idx]
      if can_split?(hand)
        puts "Player #{@player_id}, (h)it, (s)tand, (d)ouble, or s(p)lit on"
      else
        puts "Player #{@player_id}, (h)it, (s)tand, or (d)ouble on"
      end
      puts hand.to_s
      case gets.chomp
      when "h", "hit" then hit(hand)
      when "s", "stand" then stand(hand)
      when "d", "double" then double(hand)
      when "p", "split" then split(hand)
      else choose
      end
      idx += 1
    end
  end

  def hit(hand)
    p "hit"
  end

  def stand(hand)
    p "stand"
  end

  def double(hand)
    p "double"
  end

  def split(hand)
    if !can_split?(hand)
      choose
    else
      self << Hand.new(hand.draw, @shoe.draw)
      hand << @shoe.draw
      puts self
      choose
    end
  end
end

puts "BLACKJACK".center(20, "=")
shoe = Shoe.new.add_deck.shuffle
players = []
puts "How many players?"
num = gets.chomp.to_i.times do
  players << Player.new(shoe)
end
puts players
players.each { |player| player.bet }
players.each { |player| player << Hand.new(shoe.draw, shoe.draw) }
puts players
players.each { |player| player.choose }
puts players
