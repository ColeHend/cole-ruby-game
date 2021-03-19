require_relative 'inventory.rb'
class PlayerParty
    attr_reader  :name
    attr_accessor :gold, :party, :inventory, :items, :maxPartySize
    def initialize
        @party = Array.new()
        @maxPartySize = 1
        @gold = 24
        @inventory = Array.new()
        @items = Array.new
        @inventory.push(Inventory.new.items["poison"])
        @inventory.push(Inventory.new.items["potion"])
    end

    def get_items
    end
    
     def use_item(spot,person)
        puts(spot)
        puts(person)
        @inventory[spot].function.call(person)
        @inventory.delete_at(spot)
     end

    def addToParty(character)
        if @party.length < @maxPartySize
            self.party.push(character)
            @party.each(){|e|puts("New Party Member Name: "+e.name+"| HP: "+e.hp.to_s)}
        end
    end

    
end