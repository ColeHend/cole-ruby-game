class Weapon
    attr_reader :name, :damage, :animation
    attr_accessor :enchantment
    def initialize(name,damage = 6,animation="slash",enchantment = nil)
        @name = name
        @damage = damage
        @animation = animation
        @enchantment = enchantment
    end
    # damage = ((wpnDMG*STR)/DEF)
end