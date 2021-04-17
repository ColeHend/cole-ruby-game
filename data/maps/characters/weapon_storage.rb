require_relative "weapon.rb"
class WeaponStorage
    def initialize()
        @weapons
        @updateMenu = nil
    end
    def register_update_function(updateFunk)
        @updateMenu = updateFunk
    end
    def take(name)
        case name
        when "bronzeSword"
            # Weapon.new(name,damage = 6,animation="slash",enchantment = nil)
            damage = 6
            animation="slash"
            enchantment = nil
            bronzeSword = Weapon.new("Bronze Sword",damage,animation,enchantment)
            return bronzeSword
        when "ironSword"
            # Weapon.new(name,damage = 6,animation="slash",enchantment = nil)
            damage = 10
            animation="slash"
            enchantment = nil
            bronzeSword = Weapon.new("Iron Sword",damage,animation,enchantment)
            return bronzeSword
        end
    end
end