require_relative "character_base.rb"
class PlayerCharacter < CharacterBase
    attr_reader :playerLevel, :exp
    attr_accessor :currentHP
    def initialize(name,hp)
        self.name = name
        self.hp = hp
        @currentHP = hp
        @playerLevel = 1
        @exp = 0
        @lvlUpExp = (150*@playerLevel) + (50 * @playerLevel)

    end


    def level_up()
        #stat increases and stuff
        @exp = (@exp-@lvlUpExp)
        @playerLevel = (@playerLevel+1)
        self.hp = (self.hp+5)
        @lvlUpExp = (150*@playerLevel) + (50 * @playerLevel)
    end

    def give_xp(expAmt)
        @exp = (@exp+expAmt)
        while @exp > @lvlUpExp
            level_up()
            puts("XP  -> "+$scene_manager.feature["party"].party[0].exp.to_s)
            puts("LVL -> "+$scene_manager.feature["party"].party[0].playerLevel.to_s)
        end
    end

end