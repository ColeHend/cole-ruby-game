class Weapon
    attr_accessor :name, :damage, :animation, :range
    attr_accessor :enchantment, :unequipEnchantment ,:type, :cooldown,:codeName
    def initialize(name,codeName,damage = 6,animation="slash",enchantment = nil,cooldown = 350,rangeBoost=0,unequipEnchantment=nil)
        @name = name
        @codeName = codeName
        @type = "weapon"
        @damage = damage
        @range = rangeBoost
        @cooldown = cooldown
        @animation = animation
        @enchantment = enchantment
        @unequipEnchantment = unequipEnchantment
    end
    # damage = ((wpnDMG*STR)/DEF)
end