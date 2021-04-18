require_relative 'inventory.rb'
class PlayerParty
    attr_reader  :name
    attr_accessor :gold, :party, :inventory, :items, :maxPartySize, :deathCap, :deathTotal
    def initialize
        @party = Array.new()
        @maxPartySize = 2
        @gold = 24
        @inventory = Inventory.new()
        @inventory.add_item("potion")
        @inventory.add_item("potion")
        @inventory.add_item("potion")
        @inventory.add_item("megaPotion")
        @inventory.add_item("megaPotion")
        @inventory.add_item("megaPotion")
        @inventory.add_weapon("ironMace")
        @inventory.add_weapon("ironSword")
        @inventory.add_weapon("bronzeMace")
        @inventory.add_weapon("bronzeSword")
        @inventory.add_armor("leatherHelm")
        @inventory.add_armor("leatherArmor")
        @deathCap = @maxPartySize
        @deathTotal = 0
    end

    def get_items
    end

    def addToParty(character)
        if @party.length < @maxPartySize
            self.party.push(character)
            puts("New Party Member Name: #{character.name}| HP: #{character.hp}")
        end
    end
    
    def unequip(equipType,equipSpot)
        case equipType
        when "weapon"
            if @party[equipSpot].weapon != nil
                @inventory.weapons.push(@party[equipSpot].weapon)
                @party[equipSpot].weapon = nil
                
            end
        when "shield"
            if @party[equipSpot].shield != nil
                @inventory.armor.push(@party[equipSpot].shield)
                @party[equipSpot].shield = nil
            end
        when "head"
            if @party[equipSpot].helm != nil
                @inventory.armor.push(@party[equipSpot].helm)
                @party[equipSpot].helm = nil
            end
        when "neck"
            if @party[equipSpot].necklace != nil
                @inventory.armor.push(@party[equipSpot].necklace)
                @party[equipSpot].necklace = nil
            end
        when "body"
            if @party[equipSpot].chest != nil
                @inventory.armor.push(@party[equipSpot].chest)
                @party[equipSpot].chest = nil
            end
        when "hands"
            if @party[equipSpot].hands != nil
                @inventory.armor.push(@party[equipSpot].hands)
                @party[equipSpot].hands = nil
            end
        when "legs"
            if @party[equipSpot].legs != nil
                @inventory.armor.push(@party[equipSpot].legs)
                @party[equipSpot].legs = nil
            end
        when "feet"
            if @party[equipSpot].feet != nil
                @inventory.armor.push(@party[equipSpot].feet)
                @party[equipSpot].feet = nil
            end
        end
    end
    def equip(equipment,equipSpot)
        if equipment.is_a?(Weapon) == true|| equipment.is_a?(Armor) == true
            case equipment.type
            when "weapon"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].weapon = equipment
                weapon =@inventory.weapons
                weapon = (weapon - [equipment])
            when "shield"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].shield = equipment
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "helm"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].helm = equipment
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "neck"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].necklace = equipment
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "body"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].chest = equipment
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "hands"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].hands = equipment
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "legs"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].legs = equipment
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "feet"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].feet = equipment
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            end
        end
    end
    
end
