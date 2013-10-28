module EntityActions

    def take_card (card, hand=0)
        @hands[hand] ||= Hand.new(self)
        @hands[hand].add_card(card)
    end

    def hand(index=0)
        @hands[index] ||= Hand.new(self)
        return @hands[index]
    end

    def empty_hands
        @hands = []
    end

end
