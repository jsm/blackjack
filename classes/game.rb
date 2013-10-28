class Game

    STARTING_AMOUNT = 1000

    attr_reader :dealer, :turn, :players

    def initialize(players)
        players.each do |player|
            player.empty_hands
            player.current_game = self
        end
        @players = players
        @dealer = Dealer.new(Deck.new)
        @turn = 0
        @finished = false
        @players.each { |player| player.empty_hands }
        2.times do
            (@players + [@dealer]).each do |player|
                player.take_card(@dealer.deal)
            end
        end
    end

    def increment_turn
        @turn += 1
    end

    def make_decision(decision, hand)
        case decision.name.downcase
        when "hit" then
            hand.add_card(@dealer.deal)
        when "stand" then
        when "double down" then
            hand.double_bet
            hand.add_card(@dealer.deal)
        when "split" then
            hand.split
        else
            raise ArgumentError, "No such possible decision"
        end
    end

    def make_dealer_decision
        decision = @dealer.make_decision
        self.make_decision(decision, @dealer.hand)
        return decision
    end

    def finish
        @finished = true
        hands = @players.inject([]){|agg, player| agg + player.hands}
        best_score = hands.collect(&:best_score).max rescue 0
        winners = hands.select{|hand| hand.best_score == best_score}
        if best_score > @dealer.hand.best_score
            winners.each {|winner| winner.player.wealth += winner.bet*2}
            winner = "Players #{winners.collect(&:player).collect(&:index).join(", ")} won!"
        else
            winner = "Looks like the dealer won :("
        end
        return "\n\n" + winner + self.to_s
    end

    # Nicely print out the Game State
    def to_s
        # Get the maximum lengths of line elements to equalize the output formats
        max_name = "Player #{@players.count-1}".length
        max_currency = " ($#{@players.collect(&:wealth).max})".length
        lines = []
        dealer_line = "Dealer"
        player_name_line = "Player"
        player_wealth_line_start = " ($"
        player_wealth_line_end = ")"
        lines << dealer_line + "#{" " * (max_name - dealer_line.length + max_currency)}: #{@dealer.hand}"
        @players.each_with_index do |player, player_index|
            player_lines = []
            player_lines << player_name_line + "#{" " * (max_name - player_name_line.length - player_index.to_s.length)}#{player_index}"
            player_lines << player_wealth_line_start + "#{" " * (max_currency - player_wealth_line_start.length - player_wealth_line_end.length - player.wealth.to_s.length)}#{player.wealth}#{player_wealth_line_end}"
            text = player_lines.join
            player.hands.each_with_index do |hand, hand_index|
                lines << "#{text}: #{hand.to_s}"
                text = " " * text.length if hand_index == 0
            end
        end
        longest_line_length = lines.collect(&:length).max
        lines.collect! do |line|
            line + " " * (longest_line_length - line.length)
        end
        lines.collect! do |line|
            "| #{line} |"
        end
        turn_line = "ROUND #{@turn}"
        turn_line = "END RESULT" if @finished
        longest_line_length = lines.collect(&:length).max
        turn_line_diff = longest_line_length - turn_line.length
        lines.insert(0, "=" * (turn_line_diff/2) + turn_line +  "=" * (turn_line_diff/2+turn_line_diff%2))
        lines << "=" * longest_line_length
        return "\n\n\n" << lines.join("\n") << "\n\n"
    end

end
