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
            spell = PlayerCharacter.new("Firebolt",1)
            collisionDetect = MoveCollision.new
            manaCost = 2 #does nothing
            mDMG = 2
            range = 5 * 32
            spell.totalArmor = 1
            animName = "fire"
            cooldown = 750
            spellEff = ->(){
                defender = collisionDetect.check_collision(object,8,true)
                if defender.is_a?(Event)
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
            return Magic.new(spellName,range,object,spell,spellEff,animName,cooldown)
        when "fireball"
            object = $scene_manager.register_object("fireball","fireball",0,0,32,32,4,4)
            spell = PlayerCharacter.new("Fireball",1)
            collisionDetect = MoveCollision.new
            manaCost = 4 #does nothing
            mDMG = 5
            range = 8*32
            spell.totalArmor = 1
            animName = "fire"
            cooldown = 750
            spellEff = ->(){
                defender = collisionDetect.check_collision(object,8,true)
                if defender.is_a?(Event)
                    damage = FightCenter.new("damage",defender).magicDamage_calc(mDMG,spell.getMod(@int),defender.battle.mRes)
                    @animation.play_animation(animName,(defender.x - 86) ,(defender.y - 86) ,nil)
                    puts("fireball hit!")
                    defender = defender.battle
                    defender.currentHP -= damage
                    damageInfo(defender,mDMG,damage)
                    
                else
                    @animation.play_animation(animName,(object.x - 96) ,(object.y - 96),nil)
                    puts("fireball miss!")
                end
                spell.currentHP = 0
            }
            return Magic.new(spellName,range,object,spell,spellEff,animName,cooldown)
        when "natureBolt"
            object = $scene_manager.register_object("naturebolt","natureBolt",0,0,32,32,4,4)
            spell = PlayerCharacter.new("Naturebolt",1)
            collisionDetect = MoveCollision.new
            manaCost = 4 #does nothing
            mDMG = 3
            range = 8 * 32
            spell.totalArmor = 1
            animName = "earthExplosion"
            cooldown = 750
            spellEff = ->(){
                defender = collisionDetect.check_collision(object,8,true)
                if defender.is_a?(Event)
                    damage = FightCenter.new("damage",defender).magicDamage_calc(mDMG,spell.getMod(@int),defender.battle.mRes)
                    @animation.play_animation(animName,(defender.x - 86) ,(defender.y - 86) ,nil)
                    puts("nature bolt hit!")
                    defender = defender.battle
                    defender.currentHP -= damage
                    damageInfo(defender,mDMG,damage)
                    
                else
                    @animation.play_animation(animName,(object.x - 96) ,(object.y - 96),nil)
                    puts("nature bolt miss!")
                end
                spell.currentHP = 0
            }
            return Magic.new(spellName,range,object,spell,spellEff,animName,cooldown)
        end
    end
    def update
        @animation.update
    end
    def draw
        @animation.draw
    end
end