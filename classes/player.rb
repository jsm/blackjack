require "./modules/entity_actions.rb"
class Player
    include EntityActions

    attr_accessor :hands, :current_game, :wealth, :index

    def initialize(wealth, index)
        @wealth = wealth
        @index = index
        @hands = []
    end

    def set_starting_bet(bet)
        begin
            bet = bet.to_i
        rescue
            return false
        end
        if bet < @wealth && bet > 0
            self.hand.add_bet(bet)
            return true
        else
            return false
        end
    end

    def busted?
        return hands.all?(&:busted?)
    end

end
