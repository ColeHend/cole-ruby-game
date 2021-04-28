require_relative "weapon.rb"
class WeaponStorage
    def initialize()
        @weapons
    end
    def take(name)
        case name
        when "bigStick"
            damage = 1
            animation = "blunt"
            enchantment = nil
            cooldown = 450
            rangeBoost = 16
            return Weapon.new("Big Stick",name,damage,animation,enchantment,cooldown,rangeBoost)
        when "bronzeSword"
            damage = 7
            animation="slash"
            enchantment = nil
            cooldown = 300
            rangeBoost = 16
            return Weapon.new("Bronze Sword",name,damage,animation,enchantment,cooldown,rangeBoost)
        when "ironSword"
            damage = 18
            animation="slash"
            enchantment = nil
            cooldown = 300
            rangeBoost = 32
            return Weapon.new("Iron Sword",name,damage,animation,enchantment,cooldown,rangeBoost)
        when "bronzeMace"
            damage = 10
            animation="blunt"
            enchantment = nil
            cooldown = 600
            rangeBoost = 16
            return Weapon.new("Bronze Mace",name,damage,animation,enchantment,cooldown,rangeBoost)
        when "ironMace"
            damage = 25
            animation="blunt"
            enchantment = nil
            cooldown = 600
            rangeBoost = 0
            rangeBoost = 16
            return Weapon.new("Iron Mace",name,damage,animation,enchantment,cooldown,rangeBoost)
        when "fireBrand"
            damage = 65 + 25
            animation="fire"
            enchantment = nil
            rangeBoost = 3*32
            cooldown = 280
            return Weapon.new("Fire Brand",name,damage,animation,enchantment,cooldown,rangeBoost)
        end
    end
end