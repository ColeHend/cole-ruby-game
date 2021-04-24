require_relative "../character_player.rb"
require_relative "../../../files/play_animation.rb"
require_relative "../../abs/fight_center.rb"
require_relative "magic.rb"
class Spellbook
    def initialize(int = 12)
        @animation = PlayAnimation.new()
        @int = int
    end
    def damageInfo(defender,mDMG,damage)
        puts("-------------Magic-----------------")
        puts("beingAttacked: #{defender.name}")
        puts("magicDmg: #{mDMG}")
        puts("damage: #{damage}")
        puts("magicResistance: #{defender.mRes}")
        puts("defenderAfterHP: #{defender.currentHP}")
        puts("-------------------------------")
    end
    def spell(spellName)
        case spellName
        when "firebolt"
            object = $scene_manager.register_object("firebolt","fireshotCharacter",0,0,32,32,4,4)
            spell = PlayerCharacter.new("firebolt",1)
            collisionDetect = MoveCollision.new
            manaCost = 2 #does nothing
            mDMG = 2
            range = 5
            spell.totalArmor = 1
            animName = "fire"
            cooldown = 750
            spellEff = ->(){
                defender = collisionDetect.check_collision(object,8,true)
                if defender != nil && defender != true
                    damage = FightCenter.new("damage",defender).magicDamage_calc(mDMG,spell.getMod(@int),defender.battle.mRes)
                    @animation.play_animation("fire",(defender.x - 86) ,(defender.y - 86) ,nil)
                    puts("firebolt hit!")
                    defender = defender.battle
                    defender.currentHP -= damage
                    damageInfo(defender,mDMG,damage)
                else
                    @animation.play_animation("fire",(object.x - 96) ,(object.y - 96),nil)
                    puts("firebolt miss!")
                end
                spell.currentHP = 0
            }
            array = [object,spell,spellEff,animName,cooldown,spellName,range]
            return array
        when "fireball"
            object = $scene_manager.register_object("fireball","fireball",0,0,32,32,4,4)
            spell = PlayerCharacter.new("fireball",1)
            collisionDetect = MoveCollision.new
            manaCost = 4 #does nothing
            mDMG = 5
            range = 8
            spell.totalArmor = 1
            animName = "fire"
            cooldown = 750
            spellEff = ->(){
                defender = collisionDetect.check_collision(object,8,true)
                if defender != nil && defender != true
                    damage = FightCenter.new("damage",defender).magicDamage_calc(mDMG,spell.getMod(@int),defender.battle.mRes)
                    @animation.play_animation("fire",(defender.x - 86) ,(defender.y - 86) ,nil)
                    puts("fireball hit!")
                    defender = defender.battle
                    defender.currentHP -= damage
                    damageInfo(defender,mDMG,damage)
                    
                else
                    @animation.play_animation("fire",(object.x - 96) ,(object.y - 96),nil)
                    puts("fireball miss!")
                end
                spell.currentHP = 0
            }
            array = [object,spell,spellEff,animName,cooldown,spellName,range]
            return array
        end
    end
    def update
        @animation.update
    end
    def draw
        @animation.draw
    end
end