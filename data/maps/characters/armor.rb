class Armor
    attr_accessor :name, :armor, :type, :enchantment, :codeName
    def initialize(name,codeName,type,armor = 1,enchantment = nil)
        @name = name
        @codeName = codeName
        @armor = armor
        @type = type
        @enchantment = enchantment
    end
end