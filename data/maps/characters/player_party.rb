class PlayerParty
    attr_reader  :name
    attr_accessor :gold, :party, :inventory
    def initialize
        @party = Array.new()
        @inventory = Array.new()
        @gold = 24 
    end
     def use_item(spot,person)
        @inventory[spot].function.call(person)
        @inventory.delete_at(spot)
     end

    def addToParty(character)
        self.party.push(character)
        @party.each(){|e|puts("New Party Member Name: "+e.name+"| HP: "+e.hp.to_s)}
    end
end