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

    
end
