require "./classes/card.rb"

class Deck

    def initialize()
        self.reset
    end

    def reset
        @cards = []
        Card::VALUES.each do |value|
            Card::SUITS.each do |suit|
                @cards.insert((rand*(@cards.count+1)).to_i, Card.new(value, suit))
            end
        end
    end

    def get_card
        if @cards.count > 0
            return @cards.pop
        else
            self.reset
        end
    end

end
