require_relative "item.rb"
require_relative "weapon.rb"
require_relative "armor.rb"
class Inventory
    attr_reader :items, :weapons, :armor
    def initialize
        @items   = Array.new
        @weapons = Hash.new
        @armor   = Hash.new
        @updateMenu = nil

        
        add_poison()
        add_poison()
        add_poison()
        add_poison()
        add_poison()
        
        add_potion()
        add_potion() 

    end 
    def register_update_function(updateFunk)
        @updateMenu = updateFunk
    end
    def use_item(name,person)
        @items[name].function.call(person)
    end

    def add_potion
        potion = Item.new("potion",->(person){
            person.currentHP = person.hp 
            @items.delete(potion)
            @updateMenu.call
        })
        @items.push(potion)
    end

    def add_poison
        posion = Item.new("poison",->(person){
            person.currentHP -= 2
            @items.delete(posion)
            @updateMenu.call
        })
        @items.push(posion)
    end
end
