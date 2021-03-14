class PlayerParty
    attr_reader  :name
    attr_accessor :gold, :party, :inventory
    def initialize
        @party = Array.new()
        @inventory = Array.new()
        @gold = 24 
    end
     def use_item(spot,person)
        puts(spot)
        puts(person)
        @inventory[spot].call(person)
        @inventory.delete_at(spot)
        $scene_manager.feature["party"].inventory = @inventory
     end

    def addToParty(character)
        self.party.push(character)
        @party.each(){|e|puts("New Party Member Name: "+e.name+"| HP: "+e.hp.to_s)}
    end
end