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
            ghost = PlayerCharacter.new("ghost",20.0,12,12,12,12)
            ghost.weapon = Weapon.new("GhostTouch",8,"blunt",350)
            ghost.totalArmor = 12
            ghost.mRes = 10
            ghost.exp = 500 # gives 5% of 
            ghost.hateGroup = "undead"
            ghost.enemyGroups = ["player","guard","charizard"] 
            return ghost
        when "goblin"
            goblin = PlayerCharacter.new("goblin",30.0,12,12,12,12,2)
            goblin.weapon = Weapon.new("Rusty Sword",6,"slash",350)
            goblin.totalArmor = 8
            goblin.exp = 800 # gives 5% of 
            goblin.hateGroup = "goblin"
            goblin.enemyGroups = ["player","guard","charizard"] 
            return goblin
        when "charizard"
            charizard = PlayerCharacter.new("charizard",75.0,14,12,12,12,2)
            charizard.weapon = Weapon.new("Claws",12,"slash",350)
            charizard.totalArmor = 14
            charizard.mRes = 12
            charizard.exp = 8000 # gives 5% of 
            charizard.hateGroup = "charizard"
            charizard.knownSpells = ["fireball","firebolt"]
            charizard.enemyGroups = ["player","guard","undead","goblin"] 
            return charizard
        end

    end
end