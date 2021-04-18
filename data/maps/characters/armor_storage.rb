require_relative "armor.rb"
class ArmorStorage
    def initialize()
        @armors
    end
    def take(name)
        #Types Are : "head","neck", "body", "hands", "legs", "feet"
        case name
        when "leatherHelm"
            type = "head"
            armor = 5
            enchantment = nil
            return Armor.new("Leather Helm",type,armor,enchantment)
        when "leatherArmor"
            type = "body"
            armor = 5
            enchantment = nil
            return Armor.new("Leather Armor",type,armor,enchantment)
        end
    end
end