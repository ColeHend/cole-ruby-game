class ItemStorehouse
    def initialize(itemList)
        @items = itemList
        @updateMenu = nil
    end
    def register_update_function(updateFunk)
        @updateMenu = updateFunk
    end
    def take(name)
        case name
        when "potion"
            healAmnt = 5
            potion = Item.new("potion",->(person){
                if (person.currentHP + healAmnt) <= person.hp
                    person.currentHP += healAmnt 
                elsif (person.currentHP + healAmnt) > person.hp
                    person.currentHP = person.hp
                end
                @items.delete(potion)
                @updateMenu.call
            })
            return potion
        when "mega potion"
            healAmnt = 20
            megaPotion = Item.new("Mega Potion",->(person){
                if (person.currentHP + healAmnt) <= person.hp
                    person.currentHP += healAmnt 
                elsif (person.currentHP + healAmnt) > person.hp
                    person.currentHP = person.hp
                end 
                @items.delete(megaPotion)
                @updateMenu.call
            })
            return megaPotion
        end
    end
end