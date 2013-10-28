class Hand

    attr_accessor :bet, :player

    def initialize(player)
        @cards = []
        @player = player
        @bet = 0
    end

    def scores(index=0)
        return [0] unless index < @cards.count

        possible_scores = []
        @cards[index].points.each do |point|
            self.scores(index+1).each do |score|
                possible_scores << point + score
            end
        end

        return possible_scores.uniq
    end

    def best_score
        best = self.scores.select{|score| score < 22}
        best << 0
        return best.max
    end

    def add_card(card)
        @cards << card
    end

    def add_bet(bet)
        @player.wealth -= bet
        self.bet += bet
    end

    def double_bet
        self.add_bet(@bet)
    end

    def split
        new_hand = Hand.new(@player)
        new_hand.add_card(@cards.pop)
        new_hand.add_bet(@bet)
        @player.hands << new_hand
    end

    def busted?
        return self.scores.min > 21
    end

    def possible_decisions
        possible = []
        return possible if self.busted?
        possible << Decision.find_decision("h")
        possible << Decision.find_decision("s")
        possible << Decision.find_decision("d") unless @player.wealth < @bet
        possible << Decision.find_decision("x") if self.can_split?
        return possible
    end

    def can_split?
        # Only split on the first turn
        return false if @player.current_game.turn > 1
        return false if @player.wealth < @bet
        values = @cards.collect(&:value)
        # Check if hand has a duplicate card
        return true if values.count != values.uniq.count
        return false
    end

    def to_s
        string = ""
        string << "BUSTED[" if self.busted?
        string << @cards.collect(&:to_s).join(",")
        string << "]" if self.busted?

        string << " ($#{@bet})" if @player.respond_to?(:wealth)
        string << " SCORE: #{self.scores.inspect}" if $DEBUG
        string << " BEST SCORE: #{self.best_score.inspect}" if $DEBUG
        return string
    end

end
