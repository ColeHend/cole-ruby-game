require_relative "weapon.rb"
class WeaponStorage
    def initialize()
        @weapons
    end
    def take(name)
        case name
        when "bronzeSword"
            damage = 6
            animation="slash"
            enchantment = nil
            return Weapon.new("Bronze Sword",damage,animation,enchantment)
        when "ironSword"
            damage = 10
            animation="slash"
            enchantment = nil
            return Weapon.new("Iron Sword",damage,animation,enchantment)
        when "bronzeMace"
            damage = 6
            animation="blunt"
            enchantment = nil
            return Weapon.new("Bronze Mace",damage,animation,enchantment)
        when "ironMace"
            damage = 10
            animation="blunt"
            enchantment = nil
            return Weapon.new("Iron Mace",damage,animation,enchantment)
        end
    end
end