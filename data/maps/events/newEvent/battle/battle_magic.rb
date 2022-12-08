class Battle_Magic
    def initialize
    end
end
class Spell
    attr_accessor :name, :range, :object, :stability, :animName, :cooldown, :element, :damage, :target, :effect, :triggered
    def initialize(name,range,object,stability,effect,animName,cooldown)
        @name = name
        @range = range
        @object = object
        @stability = stability
        @animName = animName
        @effect = effect
        @element = element
        @damage = damage
        @target = target
        @cooldown = cooldown
        @triggered = false
    end
end
class Spell_Casting
    def initialize(eventName,int)
        @spellList = Spellbook.new(int)
        @animation = PlayAnimation.new()
        @moveControl = Control_movement.new("spell#{@x}")
    end
    def ranged_shot(targetObject,spellEVT,facing)
        range = spellRange/4
        u = 0
            Thread.new{
                collisionDetect = MoveCollision.new
                until u > range do
                    @moveControl.Move(spellEVT.vector,targetObject,facing,1,4)
                    if collisionDetect.check_collision(targetObject,0) == true
                        spellEVT.activate_event
                        break
                    elsif collisionDetect.check_collision(targetObject,0) != true && u == range
                        spellEVT.activate_event
                        break
                    end
                    u += 1
                end
            }
    end
    def ranged_casting(spell,facing,spellName)
        
        spellCast = @spellList.spell(spellName)
        #(spellName,range,object,spell,spellEff,animName,cooldown)
        spellObj = spellCast.object
        spellObj.x = attackObj.x
        spellObj.y = attackObj.y
        spellRange = spellCast.range
        spellStability = spellCast.stability
        spellEff = spellCast.effect
        spellOnHit = spellCast.animName

        event = Event.new(spellObj, spellEff,spellStability)
        createSpell = ->(){
            @currentEvents =  $scene_manager.scene["map"].currentMap.events
            @activeSpells.push(event)
        }
        
        dist = 2
        @animation.play_animation(spellOnHit,(event.x - 86) ,(event.y - 86) ,nil)
        draw_character(event.eventObject, (facing) ,1)
        case facing
        when "up"
            spellObj.y -= (attackObj.h+dist)
            createSpell.call
            make_shot(spellObj,event,"up",spellStability,spellRange)
        when "down"
            spellObj.y += (attackObj.h+dist)
            createSpell.call
            make_shot(spellObj,event,"down",spellStability,spellRange)
        when "left"
            spellObj.x -= (attackObj.w+dist)
            createSpell.call
            make_shot(spellObj,event,"left",spellStability,spellRange)
        when "right"
            spellObj.x += (attackObj.w+dist)
            createSpell.call
            make_shot(spellObj,event,"right",spellStability,spellRange)
        end
        
    end
end
