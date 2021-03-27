require_relative "character_base.rb"
class PlayerCharacter < CharacterBase
    attr_accessor :currentHP, :alive, :exp, :playerLevel
    def initialize(name,hp,str=10,dex=10,int=10,con=10,cha=10,wis=10)
        self.name = name
        self.hp = hp
        @alive = true
        @currentHP = hp
        @playerLevel = 1
        @exp = 0
        @lvlUpExp = (1000*@playerLevel) 
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

end