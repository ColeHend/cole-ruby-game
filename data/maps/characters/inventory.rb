require_relative "item.rb"
require_relative "weapon.rb"
require_relative "armor.rb"
require_relative "item_storehouse.rb"
class Inventory
    attr_reader :items, :weapons, :armor
    def initialize
        puts("Inventory Initializing")
        @items   = Array.new
        @weapons = Array.new
        @armor   = Array.new
        @itemStorehouse = ItemStorehouse.new(@items)
        

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
        puts("Added to Inventory: #{daItem.name}")
        @items.push(daItem)
    end
end
