class Weapon
    attr_accessor :name, :damage, :animation
    attr_accessor :enchantment, :type
    def initialize(name,damage = 6,animation="slash",enchantment = nil)
        @name = name
        @type = "weapon"
        @damage = damage
        @animation = animation
        @enchantment = enchantment
    end
    # damage = ((wpnDMG*STR)/DEF)
end