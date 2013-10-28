# Load Library Files and Class Files
Dir["./lib/*.rb"].each {|file| require file }
Dir["./classes/*.rb"].each {|file| require file }
Dir["./modules/*.rb"].each {|file| require file }

$DEBUG = false

# Initialize the game

player_count = (prompt "How Many Players? ").to_i
players = player_count.times.collect{ |i| Player.new(Game::STARTING_AMOUNT, i) }

Decision.new("Hit", "h")
Decision.new("Stand", "s")
Decision.new("Double Down", "d")
Decision.new("Split", "x")

begin
    game = Game.new(players.select{|player| player.wealth > 0})

    game.players.each do |player|
        while player.set_starting_bet(prompt("Player #{player.index} please set a starting bet less than #{player.wealth}: ")) == false ; end
    end

    continue = true

    # Keep taking turns until the game is over
    while continue
        continue = false
        # Increment the Turn counter
        game.increment_turn

        # Have each player take a turn
        game.players.select{|player| player.busted? == false}.each do |player|
            puts game
            puts turn_message = "Player #{player.index}'s Turn"
            puts "-" * turn_message.length

            # Have each player make a decision for each hand they have
            player.hands.select{|hand| hand.busted? == false}.each_with_index do |hand, hand_index|
                # Get all possible decisions
                possible_decisions = hand.possible_decisions
                decision = nil
                while hand.busted? == false && (decision.nil? || decision.is_hit?)
                    decision = nil

                    # Get a decision from the player
                    while Decision.find_decision(decision).nil?
                        puts "Choose a decision for Hand #{hand}"
                        decision_text = possible_decisions.collect do |decision|
                            "#{decision.name}(#{decision.shortcut})"
                        end.join(", ")
                        decision = prompt "#{decision_text}: "
                    end
                    decision = Decision.find_decision(decision.downcase)
                    continue = true if decision.is_hit?

                    # Play the decision
                    game.make_decision(decision, hand)
                end
            end
        end

        # Have the dealer take a turn
        puts game
        puts turn_message = "Dealers's Turn"
        puts "-" * turn_message.length
        dealer_decision = game.make_dealer_decision
        continue = true if dealer_decision.is_hit?
        puts "\nDealer Decision: #{dealer_decision.name}"
        puts "Dealer's Hand: #{game.dealer.hand}"
    end


    puts game.finish

end while (prompt "\nPlay again?(y/n) ") == "y"

puts "\nThanks for playing BlackJack!"
puts "Created By: Jon San Miguel"
puts "Github: github.com/jsm"


