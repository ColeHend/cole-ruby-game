require_relative "character_base.rb"
require_relative "weapon.rb"
require_relative "armor.rb"
class PlayerCharacter < CharacterBase
    attr_accessor :currentHP, :alive, :exp, :playerLevel, :weapon, :shield, :helm, :necklace, :chest, :legs, :feet, :hands
    attr_reader :totalArmor, :str, :dex, :int, :con,:hp
    def initialize(name,hp,str=14,dex=12,int=12,con=12)
        self.name = name
        self.hp = hp
        @alive = true
        @currentHP = hp
        @playerLevel = 1
        @exp = 0
        @str, @dex, @int, @con = str, dex, int, con
        @lvlUpExp = (1000*@playerLevel)
        @weapon = Weapon.new("Sword",10)
        @shield = nil
        @helm = nil
        @necklace = nil
        @chest = Armor.new("BreastPlate",5)
        @hands = nil
        @legs = nil
        @feet = nil
        @totalArmor = total_ac(0)
        
    end
    def getMod(stat)
        modifier = ((stat - 10)/2)
        return modifier
    end
    
    def level_up
        #stat increases and stuff
        @exp = (@exp-@lvlUpExp)
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