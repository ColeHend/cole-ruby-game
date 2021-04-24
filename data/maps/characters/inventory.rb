require_relative "item.rb"
require_relative "weapon.rb"
require_relative "armor.rb"
require_relative "item_storehouse.rb"
require_relative "weapon_storage.rb"
require_relative "armor_storage.rb"
class Inventory
    attr_reader :items, :weapons, :armor
    def initialize
        puts("Inventory Initializing")
        @items   = Array.new
        @weapons = Array.new
        @armor   = Array.new
        @itemStorehouse = ItemStorehouse.new(@items)
        @weaponStorage = WeaponStorage.new()
        @armorStorage = ArmorStorage.new()

    end 
    def takeItem(name)
       return @itemStorehouse.take(name)
    end
    def takeWeapon(name)
        return @weaponStorage.take(name)
     end
    def takeArmor(name)
        return @armorStorage.take(name)
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
    def add_weapon(name)
        daItem = takeWeapon(name)
        puts("Added to Inventory: #{daItem.name}")
        @weapons.push(daItem)
    end
    def add_armor(name)
        daItem = takeArmor(name)
        puts("Added to Inventory: #{daItem.name}")
        @armor.push(daItem)
    end
end
