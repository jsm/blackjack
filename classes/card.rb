# -*- coding: utf-8 -*-
class Card

    VALUES = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    SUITS = [:spade, :heart, :club, :diamond]

    POINT_MAP = {
        "1" => 1,
        "2" => 2,
        "3" => 3,
        "4" => 4,
        "5" => 5,
        "6" => 6,
        "7" => 7,
        "8" => 8,
        "9" => 9,
        "10" => 10,
        "J" => 10,
        "Q" => 10,
        "K" => 10,
        "A" => [1,11]
    }

    SUIT_MAP = {
        :spade => "♠",
        :heart => "♥",
        :club => "♣",
        :diamond => "♦"
    }

    attr_accessor :value, :suit

    def initialize(value, suit)
        @value = value
        @suit = suit
    end

    def points
        return Array(POINT_MAP[self.value])
    end

    def to_s
        return @value
        # return "#{@value}#{SUIT_MAP[@suit]}"
    end

end
