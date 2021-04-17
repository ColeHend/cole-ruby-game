require_relative "item.rb"
require_relative "weapon.rb"
require_relative "armor.rb"
require_relative "item_storehouse.rb"
class Inventory
    attr_reader :items, :weapons, :armor
    def initialize
        @items   = Array.new
        @weapons = Hash.new
        @armor   = Hash.new
        @itemStorehouse = ItemStorehouse.new(@items)
        add_item("potion")
        add_item("potion")
        add_item("potion")
        add_item("mega potion")
        add_item("mega potion")
        add_item("mega potion")

    end 
    def takeItem(name)
       return @itemStorehouse.take(name)
    end
    def register_update_function(updateFunk)
        return @itemStorehouse.register_update_function(updateFunk)
    end
    def use_item(name,person)
        @items[name].function.call(person)
    end

    def add_item(name)
        daItem = takeItem(name)
        puts(daItem.name)
        @items.push(daItem)
    end
end
