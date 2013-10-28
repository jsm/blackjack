require "./modules/entity_actions.rb"
class Dealer
    include EntityActions

    def initialize(deck)
        @deck = deck
        @hands = []
    end

    def deal
        return @deck.get_card
    end

    def make_decision
        return  Decision.find_decision("h") if self.hand.scores.min < 17
        return  Decision.find_decision("s")
    end

end
