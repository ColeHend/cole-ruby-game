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
        when "Fred"
            hp = 30.0
            str = 14
            dex = 12
            int = 12
            con = 12
            mRes = 2
            fred = PlayerCharacter.new("Fred",hp,str,dex,int,con,mRes)
            fred.weapon = WeaponStorage.new.take("bigStick")
            fred.shield = ArmorStorage.new.take("potLid")
            fred.helm = ArmorStorage.new.take("sunHat")
            fred.necklace = ArmorStorage.new.take("charm")
            fred.chest = ArmorStorage.new.take("cottonShirt")
            fred.hands = ArmorStorage.new.take("cottonGloves")
            fred.legs = ArmorStorage.new.take("cottonPants")
            fred.feet = ArmorStorage.new.take("cottonShoes")
            fred.hateGroup = "player"
            fred.enemyGroups = @enemyGroups
            fred.allSpells = [[1,"natureBolt"],[4,"fireball"]]
            fred.currentSpell = Spellbook.new.spell("natureBolt")
            fred.knownSpells = ["natureBolt"]
             
            return fred
        end

    end
end