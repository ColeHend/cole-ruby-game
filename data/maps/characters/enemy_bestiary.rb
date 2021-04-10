require_relative "character_player.rb"
require_relative "weapon.rb"
class Bestiary 
    def initialize()
    end
    def enemy(enemyName) 
        case enemyName # (name,hp,str,dex,int,con)
        when "god"
            god = PlayerCharacter.new("god",1000000.0,12,12,12,12,100000)
            god.totalArmor = 100000
            god.hateGroup = "notouchy"
            god.enemyGroups = ["nobody"] 
            return god
        when "ghost"
            ghost = PlayerCharacter.new("ghost",15.0,12,12,12,12)
            ghost.weapon = Weapon.new("GhostTouch",15)
            ghost.totalArmor = 12
            ghost.mRes = 12
            ghost.exp = 500 # gives 5% of 
            ghost.hateGroup = "undead"
            ghost.enemyGroups = ["player","guard","goblin"] 
            return ghost
        when "goblin"
            goblin = PlayerCharacter.new("goblin",30.0,12,12,12,12,2)
            goblin.weapon = Weapon.new("Rusty Sword",8)
            goblin.totalArmor = 8
            goblin.exp = 800 # gives 5% of 
            goblin.hateGroup = "goblin"
            goblin.enemyGroups = ["player","guard","ghost"] 
            return goblin
        end

    end
end