# BLACKJACK
require_relative 'cards.rb'
require_relative 'card.rb'
require_relative 'entity.rb'

class Paint
  def self.initialize(player, dealer, shoe)
    @player = player
    @dealer = dealer
    @shoe   = shoe
  end
  def self.state
    puts "\n"*5
    str_bld = "Player has $#{@player.cash} in cash"
    str_bld << " and a $#{@player.pot} bet" unless @player.pot.zero?
    str_bld << ".\n\n"
    str_bld << "Dealer's cards:\n"
    str_bld << @dealer.hand.to_s
    str_bld << "\n\n"
    str_bld << "Player's cards:\n"
    str_bld << @player.hand.to_s
    puts str_bld
  end

end

puts "\n"*5
puts "BLACKJACK".center(20, "=")
shoe = Shoe.new.add_deck.shuffle
player =  Player.new(shoe)
dealer =  Dealer.new(shoe)
while player.continue_playing
  Paint.initialize(player, dealer, shoe)
  player.next_round
  dealer.next_round
  player.bet
  player.hand << shoe.draw
  player.hand << shoe.draw
  dealer.hand << shoe.draw
  while player.choose(player.hand)
  end
  sleep(3)
  puts "Player round over, dealer's turn"
  dealer.hand << shoe.draw
  while dealer.choose(dealer.hand)
  end
  player_value = player.hand.value.select { |value| value <= 21 }.max || 0
  dealer_value = dealer.hand.value.select { |value| value <= 21 }.max || 0
  if player.hand.status == :blackjack && dealer.hand.status == :blackjack
    puts "Player and Dealer both have Blackjack. A tie."
    player.win(1)
  elsif player.hand.status == :blackjack && dealer.hand.status != :blackjack
    puts "Player has Blackjack. Bonus payout!"
    player.win(3)
  elsif player_value >= dealer_value && player_value == 21
    puts "Player has twenty-one and beats Dealer."
    player.win(2)
  elsif player_value >= dealer_value && player_value > 0
    puts "Player beats Dealer."
    player.win(2)
  elsif player_value == dealer_value && player_value == 0
    puts "Player and Dealer both busted. A tie."
    player.win(1)
  else
    puts "House wins."
  end
  puts "\n"
end
