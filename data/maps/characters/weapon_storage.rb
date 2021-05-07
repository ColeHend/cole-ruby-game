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
            rangeBoost = 16#(name,codeName,damage = 6,animation="slash",enchantment = nil,cooldown = 350,rangeBoost=0,unequipEnchantment=nil,description = "")
            return Weapon.new("Big Stick",name,damage,animation,enchantment,cooldown,rangeBoost,nil,"")
        when "bronzeSword"
            damage = 7
            animation="slash"
            enchantment = nil
            cooldown = 300
            rangeBoost = 16
            return Weapon.new("Bronze Sword",name,damage,animation,enchantment,cooldown,rangeBoost,nil,"")
        when "ironSword"
            damage = 18
            animation="slash"
            enchantment = nil
            cooldown = 300
            rangeBoost = 32
            return Weapon.new("Iron Sword",name,damage,animation,enchantment,cooldown,rangeBoost,nil,"An Iron Sword")
        when "bronzeMace"
            damage = 10
            animation="blunt"
            enchantment = nil
            cooldown = 600
            rangeBoost = 16
            return Weapon.new("Bronze Mace",name,damage,animation,enchantment,cooldown,rangeBoost,nil,"")
        when "ironMace"
            damage = 25
            animation="blunt"
            enchantment = nil
            cooldown = 600
            rangeBoost = 0
            rangeBoost = 16
            return Weapon.new("Iron Mace",name,damage,animation,enchantment,cooldown,rangeBoost,nil,"")
        when "fireBrand"
            damage = 65 + 25
            animation="fire"
            enchantment = ->(event){
                event.dex += 20
                event.mRes += 12
            }
            unequipEnchantment = ->(event){
                event.dex -= 20
                event.mRes -= 12
            }
            rangeBoost = 3*32
            cooldown = 280
            return Weapon.new("Fire Brand",name,damage,animation,enchantment,cooldown,rangeBoost,unequipEnchantment,"Boosted Range by 3,\nincreased Physical and magical damage resistance")
        when "magicSlayer"
            damage = 12
            animation="slash"
            enchantment = ->(event){event.mRes += 4}
            unequipEnchantment = ->(event){event.mRes -= 4}
            cooldown = 300
            rangeBoost = 16
            return Weapon.new("Magician Slayer",name,damage,animation,enchantment,cooldown,rangeBoost,unequipEnchantment,"Boost Magic Resistance By 4")
        end
    end
end