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
        @weapon = WeaponStorage.new.take("ironSword")
        @shield = nil
        @helm = nil
        @necklace = nil
        @chest = Armor.new("BreastPlate",5)
        @hands = nil
        @legs = nil
        @feet = nil
        @totalArmor = total_ac(0)
        @hateGroup = "player"
        @enemyGroups = ["undead","goblin"]
    end
    def getMod(stat)
        modifier = ((stat - 10))
        return modifier
    end
    
    def level_up
        #stat increases and stuff
        @playerLevel = (@playerLevel+1)
        self.hp = (self.hp+5)
        @lvlUpExp = (1000*@playerLevel) 
        self.int = (self.int+1)
        self.con = (self.con+1)
        
    end

    def give_xp(expAmt)
        @exp += expAmt
        while @exp >= @lvlUpExp
            level_up()
        end
    end

    private #everything after here is private

    def total_ac(modifier = 0)
        totalAC = 10
        if @shield != nil
            totalAC += @shield.armor
        end
        if @helm != nil
            totalAC += @helm.armor
        end
        if @chest != nil
            totalAC += @chest.armor
        end
        if @hands != nil
            totalAC += @hands.armor
        end
        if @legs != nil
            totalAC += @legs.armor
        end
        if @feet != nil
            totalAC += @feet.armor
        end
        return totalAC + modifier
    end

end