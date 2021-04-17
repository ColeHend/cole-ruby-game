require_relative "armor.rb"
class ArmorStorage
    def initialize()
        @armors
        @updateMenu = nil
    end
    def register_update_function(updateFunk)
        @updateMenu = updateFunk
    end
    def take(name)
        case name
        when "bronzeHelm"
            armor = 5
            enchantment = nil
            return Weapon.new("Bronze Helm",armor,enchantment)
        end
    end
end