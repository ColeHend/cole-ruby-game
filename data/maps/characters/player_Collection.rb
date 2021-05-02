require_relative "character_player.rb"
require_relative "weapon_storage.rb"
require_relative "armor_storage.rb"
class PartyCollection 
    def initialize()
        @enemyGroups = ["sandslash","hitmonchan","charizard","metagross"]
    end
    def party(memberName) 
        case memberName # (name,hp,str,dex,int,con)
        when "Steve"
            hp = 30.0
            str = 14
            dex = 12
            int = 12
            con = 12
            mRes = 2
            steve = PlayerCharacter.new("Steve",hp,str,dex,int,con,mRes)
            steve.weapon = WeaponStorage.new.take("bigStick")
            steve.shield = ArmorStorage.new.take("potLid")
            steve.helm = ArmorStorage.new.take("sunHat")
            steve.necklace = ArmorStorage.new.take("charm")
            steve.chest = ArmorStorage.new.take("cottonShirt")
            steve.hands = ArmorStorage.new.take("cottonGloves")
            steve.legs = ArmorStorage.new.take("cottonPants")
            steve.feet = ArmorStorage.new.take("cottonShoes")
            steve.hateGroup = "player"
            steve.enemyGroups = @enemyGroups
            steve.allSpells = [[1,"firebolt"],[3,"natureBolt"],[5,"fireball"]]
            steve.knownSpells = ["firebolt"]
             
            return steve
        end

    end
end