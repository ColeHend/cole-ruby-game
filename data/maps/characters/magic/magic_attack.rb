require_relative "magic.rb" # (name,element,damage,effect = nil,target = nil)
require_relative "spellbook.rb" # (spellName)
require_relative "../../events/event.rb" # (object, eventTrigger, collidable, event,battle)
require_relative "../../events/event_trigger.rb"
require_relative "../../events/move_collision.rb"
require_relative "../../events/movement_control.rb"
Dir[File.join(__dir__, '..', '*.rb')].each { |file| require file }
class MagicBook
    def initialize(int = 12)
        @currentMap =  $scene_manager.scene["map"].currentMap
        @playerObj = $scene_manager.object["player"]
        @playerBattle = $scene_manager.feature["party"].party[0]
        @x = (@playerObj.x )
        @y = (@playerObj.y )
        @int = int
        @fireboltObj = $scene_manager.register_object("firebolt","fireshotCharacter",0,0,32,48,4,4)
        @activeSpells = Array.new
        @spellList = Spellbook.new(@int)
    end
    
    def make_shot(targetObject,spellEVT,facing,spellStability)
        range = 5*8
        u = 0
        until u > range do
            Move(spellEVT.vector,targetObject,facing,1,4)
            if check_collision(targetObject) == true
                spellEVT.activate_event
                break
            elsif check_collision(targetObject) != true && u == range
                spellEVT.activate_event
                break
            end
            u += 1
        end

        
    end
    def ranged_shot(attackObj,facing,spellName)
        
        spellCast = @spellList.spell(spellName)

        spellObj = spellCast[0]
        spellObj.x = attackObj.x
        spellObj.y = attackObj.y

        spellStability = spellCast[1]
        spellEff = spellCast[2]


        event = Event.new(spellObj, EventTrigger::AUTOMATIC, true, spellEff,spellStability)
        createSpell = ->(){
            @currentEvents =  $scene_manager.scene["map"].currentMap.events
            @activeSpells.push(event)
        }
        

        dist = 48
        case facing
        when "up"
            spellObj.y -= dist
            createSpell.call
            make_shot(spellObj,event,"up",spellStability)
        when "down"
            spellObj.y += dist
            createSpell.call
            make_shot(spellObj,event,"down",spellStability)
        when "left"
            spellObj.x -= dist
            createSpell.call
            make_shot(spellObj,event,"left",spellStability)
        when "right"
            spellObj.x += dist
            createSpell.call
            make_shot(spellObj,event,"right",spellStability)
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