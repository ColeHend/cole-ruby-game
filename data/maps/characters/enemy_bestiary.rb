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
            hitmonchan.weapon = Weapon.new("Mega Punch","megaPunch",15,"blunt",nil,350,4)#(name,codeName,damage = 6,animation="slash",enchantment = nil,cooldown = 350,rangeBoost=0,unequipEnchantment=nil,description = "")
            hitmonchan.totalArmor = 8
            hitmonchan.mRes = 1
            hitmonchan.exp = 50 # gives 
            hitmonchan.hateGroup = "hitmonchan"
            hitmonchan.enemyGroups = ["player","guard"] 
            return hitmonchan
        when "sandslash"
            sandslash = PlayerCharacter.new("sandslash",30.0,12,12,12,12,2)
            sandslash.weapon = Weapon.new("Slash","slash",10,"slash",nil,350,4)
            sandslash.totalArmor = 12
            sandslash.exp = 50 # gives 
            sandslash.hateGroup = "sandslash"
            sandslash.enemyGroups = ["player","guard"] 
            return sandslash
        when "charizard"
            charizard = PlayerCharacter.new("charizard",75.0,14,12,12,12,2)
            charizard.weapon = Weapon.new("Claws","claws",12,"slash",nil,350,4)
            charizard.totalArmor = 14
            charizard.mRes = 12
            charizard.exp = 160 # gives 
            charizard.hateGroup = "charizard"
            charizard.currentSpell = Spellbook.new.spell("fireball")
            charizard.knownSpells = ["fireball","firebolt"]
            charizard.enemyGroups = ["player","guard"] 
            return charizard
        when "metagross"
            metagross = PlayerCharacter.new("metagross",750.0,16,12,12,12,2)
            metagross.weapon = Weapon.new("Force Punch","forcePunch",70,"blunt",nil,250,32)
            metagross.totalArmor = 1000
            metagross.exp = 1000 # gives  
            metagross.hateGroup = "metagross"
            metagross.enemyGroups = ["player","guard"] 
            return metagross
        end

    end
end