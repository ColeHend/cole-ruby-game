require_relative "map.rb"
require_relative "scene_map.rb"
require_relative "events/event.rb"
require_relative "events/event_trigger.rb"
require_relative "events/event_base.rb"
require_relative "characters/enemy_bestiary.rb"
require_relative "../files/windowBase.rb"
require_relative "../files/dialogBox.rb"
require_relative "characters/inventory.rb"
require_relative "characters/character_npc.rb"
require "json"
class Map03 < Map
    attr_reader :name, :mapfile, :map , :events, :width, :height, :tileset, :bgm
    include WindowBase
    def initialize()
        #Variable Init
        @name = "map03"
        @mapfile = JSON.load(File.read("data/maps/map03.json"))
        @tileset = Tileset.new("mountainTileset",8,28)
        @bgm = $scene_manager.songs['serious']
        @width, @height = 40, 30
        @map = Mapper.new(@tileset,@width,@height,@mapfile)
        @bestiary = Bestiary.new()
        @events = $scene_manager.eventMap[3]
        @eventBase = [
            Event_Base.new("Event301",:sandslash,4*32,17*32,60,60,4,4,3,"sandslash","SELECT"),
            Event_Base.new("Event302",:hitmonchan,19*32,17*32,53,52,4,4,3,"hitmonchan","SELECT"),
            Event_Base.new("Event303",:charizard,12*32,2*32,62,62,4,4,3,"charizard","SELECT"),
            Event_Base.new("Event304",:metagross,2*32,4*32,61,62,4,4,3,"metagross","SELECT")
        ]

        #--------------------Events--------------------------
        #registerEvent(eventName,imgName,eventX,eventY,bbWidth,bbHeight,columns,rows,mapNumber,bestiaryName,activateType,eventTriggered=->(){})
        @map.registerEvent(@eventBase[0])
        @map.registerEvent(@eventBase[1])
        @map.registerEvent(@eventBase[2])
        @map.registerEvent(@eventBase[3])
        #---------------------------------
        $scene_manager.registerEvent(3,"Teleport301",
            Event.new(nil, ->(){
                $scene_manager.scene["map"].change_map("map01",15.5*32,2*32)
        },@bestiary.enemy("god")))
        teleport1 = $scene_manager.event["Teleport301"]
        teleport1.activateType = "TOUCH"
        teleport1.x = 15.5*32
        teleport1.y = 29.5*32
    end

    def setEventMovement
        player = $scene_manager.scene["player"]
        event301 = $scene_manager.event["Event301"] #sandslash 
        event302 = $scene_manager.event["Event302"] #hitmonchan
        event303 = $scene_manager.event["Event303"] #charizard
        event304 = $scene_manager.event["Event304"] #metagross
        if event301.battle.currentHP > 0 #set sandslash ai
            event301.activateType = "SELECT"
            event301.set_move("followPlayer",8*32,nil)
            event301.set_move("attack",8*32,nil,"melee") 
        end
        if event302.battle.currentHP > 0#set hitmonchan ai
            event302.activateType = "SELECT"
            event302.set_move("followPlayer",8*32,nil) 
            event302.set_move("attack",8*32,nil,"melee") 
        end
        if event303.battle.currentHP > 0#set charizard ai
            event303.activateType = "SELECT"
            event303.set_move("followPlayer",10*32,nil) 
            event303.set_move("attack",10*32,nil,"auto") 
        end
        if event304.battle.currentHP > 0#set metagross ai
            event304.activateType = "SELECT"
            event304.set_move("followPlayer",12*32,nil) 
            event304.set_move("attack",12*32,nil,"melee") 
        end
    end
    def draw()
        #@map.draw()
    end

    def update()
        @map.update()
        setEventMovement
    end
end
