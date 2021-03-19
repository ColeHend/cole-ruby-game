require_relative "character_base.rb"
class NpcCharacter < CharacterBase
    attr_accessor :currentHP, :alive
    def initialize(name, hp)
        self.name = name
        self.hp = hp
        @alive = true
        @currentHP = hp
        @npcLevel = 1
        @exp = 0
        @lvlUpExp = (1000*@npcLevel)
    end
    def level_up
        #stat increases and stuff
        @exp = (@exp-@lvlUpExp)
        @npcLevel = (@npcLevel+1)
        self.hp = (self.hp+5)
        @lvlUpExp = (1000*@npcLevel) 
    end

    def give_xp(expAmt)
        @exp += expAmt
        while @exp > @lvlUpExp
            level_up()
            #puts("XP  -> "+$scene_manager.feature["party"].party[0].exp.to_s)
            #puts("LVL -> "+$scene_manager.feature["party"].party[0].npcLevel.to_s)
        end
    end
end