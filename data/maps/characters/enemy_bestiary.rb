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
        when "npc"
            npc = PlayerCharacter.new("npc",10.0,12,12,12,12,1)
            npc.hateGroup = "npc"
            npc.enemyGroups = ["nothing"]
            return npc
        when "hitmonchan"
            hitmonchan = PlayerCharacter.new("hitmonchan",20.0,12,12,12,12)
            hitmonchan.weapon = Weapon.new("Mega Punch","megaPunch",15,"blunt",350)
            hitmonchan.totalArmor = 8
            hitmonchan.mRes = 1
            hitmonchan.exp = 500 # gives 5% of 
            hitmonchan.hateGroup = "hitmonchan"
            hitmonchan.enemyGroups = ["player","guard","charizard"] 
            return hitmonchan
        when "sandslash"
            sandslash = PlayerCharacter.new("sandslash",30.0,12,12,12,12,2)
            sandslash.weapon = Weapon.new("Slash","slash",10,"slash",350,8)
            sandslash.totalArmor = 12
            sandslash.exp = 800 # gives 5% of 
            sandslash.hateGroup = "sandslash"
            sandslash.enemyGroups = ["player","guard","charizard"] 
            return sandslash
        when "charizard"
            charizard = PlayerCharacter.new("charizard",75.0,14,12,12,12,2)
            charizard.weapon = Weapon.new("Claws","claws",12,"slash",350)
            charizard.totalArmor = 14
            charizard.mRes = 12
            charizard.exp = 8000 # gives 5% of 
            charizard.hateGroup = "charizard"
            charizard.currentSpell = Spellbook.new.spell("fireball")
            charizard.knownSpells = ["fireball","firebolt"]
            charizard.enemyGroups = ["player","guard","hitmonchan","sandslash"] 
            return charizard
        when "metagross"
            metagross = PlayerCharacter.new("metagross",750.0,16,12,12,12,2)
            metagross.weapon = Weapon.new("Force Punch","forcePunch",100,"blunt",250,8,128)
            metagross.totalArmor = 1000
            metagross.exp = 20000 # gives 5% of 
            metagross.hateGroup = "metagross"
            metagross.enemyGroups = ["player","guard","hitmonchan","sandslash"] 
            return metagross
        end

    end
end