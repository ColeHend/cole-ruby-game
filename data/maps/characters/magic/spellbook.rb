require_relative "../character_player.rb"
require_relative "../../../files/play_animation.rb"
require_relative "../../abs/fight_center.rb"
require_relative "magic.rb"
class Spellbook
    def initialize(int = 12)
        @animation = PlayAnimation.new()
        @int = int
    end
    def spell(spellName)
        case spellName
        when "firebolt"
            object = $scene_manager.register_object("firebolt","fireshotCharacter",0,0,32,32,4,4)
            spell = PlayerCharacter.new("firebolt",1)
            mDMG = 5
            collisionDetect = MoveCollision.new
            #
            spell.totalArmor = 1
            animName = "fire"
            spellEff = ->(){
                defender = collisionDetect.check_collision(object,8,true)
                if defender != nil && defender != true
                    damage = FightCenter.new.magicDamage_calc(mDMG,spell.getMod(@int),defender.battle.mRes)
                    @animation.play_animation("fire",(defender.x - 86) ,(defender.y - 86) ,nil)
                    puts("firebolt hit!")
                    defender = defender.battle
                    puts("-----magic--------#{defender.name}----------")
                    puts("damage: #{damage}")
                    puts("mRes: #{defender.mRes}")
                    puts("defenderBeforeHP: #{defender.currentHP}/#{defender.hp}")
                    defender.currentHP -= damage
                    puts("defenderAfterHP: #{defender.currentHP}/#{defender.hp}")
                    puts("------------------------------------")
                else
                    @animation.play_animation("fire",(object.x - 96) ,(object.y - 96),nil)
                    puts("firebolt miss!")
                end
                spell.currentHP = 0
            }
            array = [object,spell,spellEff,animName]
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