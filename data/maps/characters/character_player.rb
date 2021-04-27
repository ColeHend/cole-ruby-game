require_relative "character_base.rb"
require_relative "weapon_storage.rb"
require_relative "armor.rb"
class PlayerCharacter < CharacterBase
    attr_accessor :currentHP, :alive, :exp, :playerLevel,:enemyGroups, :hateGroup, :knownSpells 
    attr_accessor :weapon, :shield, :helm, :necklace, :chest, :legs, :feet, :hands, :totalArmor, :mRes
    attr_reader :str, :dex, :int, :con, :hp, :deathExp
    def initialize(name,hp,str=14,dex=12,int=12,con=12,mRes=1)
        self.name = name
        self.hp = hp
        @alive = true
        @currentHP = hp
        @playerLevel = 1
        @exp = 0
        @str, @dex, @int, @con, @mRes = str, dex, int, con, mRes
        @lvlUpExp = (1000*@playerLevel)
        @knownSpells = ["firebolt"]
        @weapon = Weapon.new("Big Stick","bigStick",1,"blunt")
        @shield = Armor.new("Pot Lid","potLid","shield",1)
        @helm = Armor.new("Sun Hat","sunHat","helm",1)
        @necklace = Armor.new("Charm","charm","necklace",1)
        @chest = Armor.new("Cotton Shirt","cottonShirt","body",1)
        @hands = Armor.new("Cotton Gloves","cottonGloves","hands",1)
        @legs = Armor.new("Cotton Pants","cottonPants","legs",1)
        @feet = Armor.new("Cotton Shoes","cottonShoes","feet",1)
        @totalArmor = total_ac(0)
        @hateGroup = "player"
        @enemyGroups = ["undead","goblin","charizard"]
    end
    def getMod(stat)
        @totalArmor = total_ac(0)
        modifier = ((stat - 10))
        return modifier
    end
    
    def level_up
        #stat increases and stuff
        @playerLevel = (@playerLevel+1)
        self.hp = (self.hp+5)
        @lvlUpExp = (1000*@playerLevel) 
        
    end

    def give_xp(expAmt)
        @exp += expAmt
        while @exp >= @lvlUpExp
            level_up()
        end
    end

    def total_ac(modifier = 0)
        totalAC = 10
        if @shield.is_a?(Armor)
            totalAC += @shield.armor
        end
        if @helm.is_a?(Armor)
            totalAC += @helm.armor
        end
        if @chest.is_a?(Armor)
            totalAC += @chest.armor
        end
        if @hands.is_a?(Armor)
            totalAC += @hands.armor
        end
        if @legs.is_a?(Armor)
            totalAC += @legs.armor
        end
        if @feet.is_a?(Armor)
            totalAC += @feet.armor
        end
        return totalAC + modifier
    end

end