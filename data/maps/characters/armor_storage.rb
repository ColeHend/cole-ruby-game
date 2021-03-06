require_relative "armor.rb"
class ArmorStorage
    def initialize()
        @armors
    end
    def take(name)
        #Types Are : "helm","necklace?", "body", "hands", "legs", "feet"
        case name
        when "sunHat"
            type = "helm"
            armor = 1
            enchantment = nil
            unequipEnchantment = nil
            description = ""
            return Armor.new("Sun Hat",name,type,armor,enchantment,unequipEnchantment,description)
        when "potLid"
            type = "shield"
            armor = 1
            enchantment = nil
            unequipEnchantment = nil
            description = ""
            return Armor.new("Pot Lid",name,type,armor,enchantment,unequipEnchantment,description)
        when "charm"
            type = "necklace"
            armor = 0
            enchantment = ->(event){event.mRes += 1}
            unequipEnchantment = ->(event){event.mRes -= 1}
            description = ""
            return Armor.new("Charm",name,type,armor,enchantment,unequipEnchantment,description)
        when "cottonShirt"
            type = "body"
            armor = 1
            enchantment = nil
            unequipEnchantment = nil
            description = ""
            return Armor.new("Cotton Shirt",name,type,armor,enchantment,unequipEnchantment,description)
        when "cottonGloves"
            type = "hands"
            armor = 1
            enchantment = nil
            unequipEnchantment = nil
            description = ""
            return Armor.new("Cotton Gloves",name,type,armor,enchantment,unequipEnchantment,description)
        when "cottonPants"
            type = "legs"
            armor = 1
            enchantment = nil
            unequipEnchantment = nil
            description = ""
            return Armor.new("Cotton Pants",name,type,armor,enchantment,unequipEnchantment,description)
        when "cottonShoes"
            type = "feet"
            armor = 1
            enchantment = nil
            unequipEnchantment = nil
            description = ""
            return Armor.new("Cotton Shoes",name,type,armor,enchantment,unequipEnchantment,description)
        when "leatherHelm"
            type = "helm"
            armor = 5
            enchantment = nil
            unequipEnchantment = nil
            description = ""
            return Armor.new("Leather Helm",name,type,armor,enchantment,unequipEnchantment,description)
        when "leatherArmor"
            type = "body"
            armor = 5
            enchantment = nil
            unequipEnchantment = nil
            description = "Hard Leather Armor"
            return Armor.new("Leather Armor",name,type,armor,enchantment,unequipEnchantment,description) 
        end#(name,codeName,type,armor = 1,enchantment = nil,unequipEnchantment = nil,description = "")
    end
end