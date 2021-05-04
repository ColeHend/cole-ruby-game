require_relative "magic.rb" # (name,element,damage,effect = nil,target = nil)
require_relative "spellbook.rb" # (spellName)
require_relative "../../events/event.rb" # (object, eventTrigger, collidable, event,battle)
require_relative "../../events/event_trigger.rb"
require_relative "../../events/move_collision.rb"
require_relative "../../events/movement_control.rb"
require_relative "../../../files/animate.rb"

Dir[File.join(__dir__, '..', '*.rb')].each { |file| require file }
class MagicBook
    attr_accessor :spellList
    def initialize(int = 12)
        @currentMap =  $scene_manager.scene["map"].currentMap
        @playerObj = $scene_manager.object["player"]
        @playerBattle = $scene_manager.feature["party"].party[0]
        @x = (@playerObj.x )
        @y = (@playerObj.y )
        @int = int
        #@fireboltObj = $scene_manager.register_object("firebolt","fireshotCharacter",0,0,32,48,4,4)
        @activeSpells = Array.new
        @spellList = Spellbook.new(@int)
        @animation = PlayAnimation.new()
        @moveControl = Control_movement.new("spell#{@x}")
    end
    
    def make_shot(targetObject,spellEVT,facing,spellStability,spellRange)
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
    

    def ranged_shot(attackObj,facing,spellName)
        
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

    def update
        @spellList.update
        
    end
    def draw
        
        if @activeSpells.length > 0
            @activeSpells.each_with_index {|e,index|
                e.draw
                @spellList.draw
            }
        end
    end
end