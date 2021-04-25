require_relative "weapon.rb"
class WeaponStorage
    def initialize()
        @weapons
    end
    def take(name)
        case name
        when "bronzeSword"
            damage = 7
            animation="slash"
            enchantment = nil
            cooldown = 300
            return Weapon.new("Bronze Sword",damage,animation,enchantment,cooldown)
        when "ironSword"
            damage = 18
            animation="slash"
            enchantment = nil
            cooldown = 300
            return Weapon.new("Iron Sword",damage,animation,enchantment,cooldown)
        when "bronzeMace"
            damage = 10
            animation="blunt"
            enchantment = nil
            cooldown = 600
            return Weapon.new("Bronze Mace",damage,animation,enchantment,cooldown)
        when "ironMace"
            damage = 25
            animation="blunt"
            enchantment = nil
            cooldown = 600
            return Weapon.new("Iron Mace",damage,animation,enchantment,cooldown)
        when "fireBrand"
            damage = 65 + 25
            animation="fireExplosion"
            enchantment = nil
            rangeBoost = 3*32
            cooldown = 280
            return Weapon.new("Fire Brand",damage,animation,enchantment,cooldown,rangeBoost)
        end
    end
end