require_relative 'inventory.rb'
class PlayerParty
    attr_reader  :name
    attr_accessor :gold, :party, :inventory, :items, :maxPartySize, :deathCap, :deathTotal, :partyActors
    def initialize
        @partyActors = Array.new
        @party = Array.new()
        @maxPartySize = 2
        @gold = 24
        @inventory = Inventory.new()
        
        @deathCap = @maxPartySize
        @deathTotal = 0
    end

    def get_items
    end

    def addToParty(characterEvent)
        if characterEvent.is_a?(Event)
            if @party.length < @maxPartySize
                self.party.push(characterEvent.battle)
                self.partyActors.push(characterEvent)
                puts("New Party Member Name: #{characterEvent.name}| HP: #{characterEvent.battle.hp}")
            end
        end
    end
    def removeFromParty(characterName)
    end
    def unequip(equipType,equipSpot)
        puts("unequip run")
        case equipType
        when "weapon"
            if @party[equipSpot].weapon.is_a?(Weapon)
                @inventory.weapons.push(@party[equipSpot].weapon)
                if @party[equipSpot].weapon.unequipEnchantment != nil
                    @party[equipSpot].weapon.unequipEnchantment.call(@party[equipSpot])
                end
                @party[equipSpot].weapon = 666
                
            end
        when "shield"
            if @party[equipSpot].shield.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].shield)
                if @party[equipSpot].shield.unequipEnchantment != nil
                    @party[equipSpot].shield.unequipEnchantment.call(@party[equipSpot])
                end
                @party[equipSpot].shield = 666
            end
        when "helm"
            if @party[equipSpot].helm.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].helm)
                if @party[equipSpot].helm.unequipEnchantment != nil
                    @party[equipSpot].helm.unequipEnchantment.call(@party[equipSpot])
                end
                @party[equipSpot].helm = 666
            end
        when "neck"
            if @party[equipSpot].necklace.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].necklace)
                if @party[equipSpot].necklace.unequipEnchantment != nil
                    @party[equipSpot].necklace.unequipEnchantment.call(@party[equipSpot])
                end
                @party[equipSpot].necklace = 666
            end
        when "body"
            if @party[equipSpot].chest.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].chest)
                if @party[equipSpot].chest.unequipEnchantment != nil
                    @party[equipSpot].chest.unequipEnchantment.call(@party[equipSpot])
                end
                @party[equipSpot].chest = 666
            end
        when "hands"
            if @party[equipSpot].hands.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].hands)
                if @party[equipSpot].hands.unequipEnchantment != nil
                    @party[equipSpot].hands.unequipEnchantment.call(@party[equipSpot])
                end
                @party[equipSpot].hands = 666
            end
        when "legs"
            if @party[equipSpot].legs.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].legs)
                if @party[equipSpot].legs.unequipEnchantment != nil
                    @party[equipSpot].legs.unequipEnchantment.call(@party[equipSpot])
                end
                @party[equipSpot].legs = 666
            end
        when "feet"
            if @party[equipSpot].feet.is_a?(Armor)
                @inventory.armor.push(@party[equipSpot].feet)
                if @party[equipSpot].feet.unequipEnchantment != nil
                    @party[equipSpot].feet.unequipEnchantment.call(@party[equipSpot])
                end
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
                if @party[equipSpot].weapon.enchantment != nil
                    @party[equipSpot].weapon.enchantment.call(@party[equipSpot])
                end
                @inventory.weapons.delete_at(@inventory.weapons.index(equipment))
            when "shield"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].shield = equipment
                if @party[equipSpot].shield.enchantment != nil
                    @party[equipSpot].shield.enchantment.call(@party[equipSpot])
                end
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "helm"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].helm = equipment
                if @party[equipSpot].helm.enchantment != nil
                    @party[equipSpot].helm.enchantment.call(@party[equipSpot])
                end
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "neck"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].necklace = equipment
                if @party[equipSpot].necklace.enchantment != nil
                    @party[equipSpot].necklace.enchantment.call(@party[equipSpot])
                end
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "body"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].chest = equipment
                if @party[equipSpot].chest.enchantment != nil
                    @party[equipSpot].chest.enchantment.call(@party[equipSpot])
                end
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "hands"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].hands = equipment
                if @party[equipSpot].hands.enchantment != nil
                    @party[equipSpot].hands.enchantment.call(@party[equipSpot])
                end
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "legs"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].legs = equipment
                if @party[equipSpot].legs.enchantment != nil
                    @party[equipSpot].legs.enchantment.call(@party[equipSpot])
                end
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            when "feet"
                unequip(equipment.type,equipSpot)
                @party[equipSpot].feet = equipment
                if @party[equipSpot].feet.enchantment != nil
                    @party[equipSpot].feet.enchantment.call(@party[equipSpot])
                end
                @inventory.armor.delete_at(@inventory.armor.index(equipment))
            end
            puts("equip run")
        end
    end
    
end
