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
    
     def use_item(spot,person)
        puts(person)
        spot.function.call(person)
        # @inventory.items[spot.name].function.call(person)
        # @inventory.items.delete(spot.name)
     end

    def addToParty(character)
        if @party.length < @maxPartySize
            self.party.push(character)
            #@party.each(){|e|puts("New Party Member Name: "+e.name+"| HP: "+e.hp.to_s)}
        end
    end

    
end
