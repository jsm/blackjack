class Decision

    attr_reader :name, :shortcut

    @@all = {}

    def self.find_decision(decision)
        return nil if decision.nil?
        return @@all[decision.downcase]
    end

    def initialize(name, shortcut)
        @name = name
        @shortcut = shortcut
        @@all[name.downcase] = self
        @@all[shortcut.downcase] = self
    end

    def is_hit?
        return @name.downcase == "hit"
    end

    def is_double?
        return @name.downcase == "double down"
    end


end
