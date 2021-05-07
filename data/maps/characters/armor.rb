class Armor
    attr_accessor :name, :armor, :type, :enchantment, :codeName,:unequipEnchantment, :description
    def initialize(name,codeName,type,armor = 1,enchantment = nil,unequipEnchantment = nil,description = "")
        @name = name
        @description = description
        @codeName = codeName
        @armor = armor
        @type = type
        @enchantment = enchantment
        @unequipEnchantment = unequipEnchantment
    end
end