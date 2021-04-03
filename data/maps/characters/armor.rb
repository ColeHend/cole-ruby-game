class Armor
    attr_reader :armor
    def initialize(name,armor = 1,enchantment = nil)
        @name = name
        @armor = armor
        @enchantment = enchantment
    end
end