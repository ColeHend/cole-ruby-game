class Armor
    attr_accessor :name, :armor, :type, :enchantment
    def initialize(name,type,armor = 1,enchantment = nil)
        @name = name
        @armor = armor
        @type = type
        @enchantment = enchantment
    end
end