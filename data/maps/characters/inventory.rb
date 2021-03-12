require_relative "item.rb"
class Inventory
    attr_reader :items, :weapons, :armor
    def initialize
        @items = Hash.new
        @weapons = Hash.new
        @armor = Hash.new

        @items["potion"] = Item.new("potion",->(person){person.currentHP = person.hp})
        @items["poison"] = Item.new("poison",->(person){person.currentHP -= 5})
    end 
    def use_item(name,person)
        @items[name].function.call(person)
    end
end