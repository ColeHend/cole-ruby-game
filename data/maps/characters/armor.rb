class Armor
    attr_accessor :name, :armor, :type, :enchantment, :codeName,:unequipEnchantment
    def initialize(name,codeName,type,armor = 1,enchantment = nil,unequipEnchantment = nil)
        @name = name
        @codeName = codeName
        @armor = armor
        @type = type
        @enchantment = enchantment
        @unequipEnchantment = unequipEnchantment
    end
end