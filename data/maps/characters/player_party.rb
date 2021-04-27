require_relative 'inventory.rb'
class PlayerParty
    attr_reader  :name
    attr_accessor :gold, :party, :inventory, :items, :maxPartySize, :deathCap, :deathTotal
    def initialize
        @party = Array.new()
        @maxPartySize = 2
        @gold = 24
        @inventory = Inventory.new()
        
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
        puts("unequip run")
        case equipType
        when "weapon"
            if @party[equipSpot].weapon.is_a?(Weapon)
                @inventory.weapons.push(@party[equipSpot].weapon)
                @party[equipSpot].weapon = 666
                
            end
        when "shield"
            if @party[equipSpot].shield.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].shield)
                @party[equipSpot].shield = 666
            end
        when "helm"
            if @party[equipSpot].helm.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].helm)
                @party[equipSpot].helm = 666
            end
        when "neck"
            if @party[equipSpot].necklace.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].necklace)
                @party[equipSpot].necklace = 666
            end
        when "body"
            if @party[equipSpot].chest.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].chest)
                @party[equipSpot].chest = 666
            end
        when "hands"
            if @party[equipSpot].hands.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].hands)
                @party[equipSpot].hands = 666
            end
        when "legs"
            if @party[equipSpot].legs.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].legs)
                @party[equipSpot].legs = 666
            end
        when "feet"
            if @party[equipSpot].feet.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].feet)
                @party[equipSpot].feet = 666
            end
        end
    end
    def equip(equipment,equipSpot)
        if equipment.is_a?(Weapon) == true|| equipment.is_a?(Armor) == true
            case equipment.type
            when "weapon"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].weapon = equipment
                #weapon =@inventory.weapons
                #weapon = (weapon - [equipment])
                @inventory.weapons.delete_at(@inventory.weapons.index(equipment))
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
            puts("equip run")
        end
    end
    
end
