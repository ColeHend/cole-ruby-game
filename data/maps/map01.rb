require_relative "map.rb"
require_relative "scene_map.rb"
require_relative "tileset.rb"
require_relative "events/event.rb"
require_relative "events/event_trigger.rb"
require_relative "../files/windowBase.rb"
require_relative "../files/optionsBox.rb"
require_relative "characters/character_player.rb"
require_relative "characters/enemy_bestiary.rb"
require_relative "characters/character_npc.rb"
require "json"

class Map01
    attr_reader :name, :map, :mapfile, :events, :width, :height, :tileset
    include WindowBase
    def initialize()
        # Initilize variables
        @name = "map01"
        @tileset = Tileset.new("CastleTownExterior",8,30)
        @mapfile = JSON.load(File.read("data/maps/map01.json"))
        @events = $scene_manager.eventMap[1]
        @map = Mapper.new(@tileset,30,20,@mapfile)
        @width = 30
        @height = 20
        @curEvnt = false
        @sceneMap = $scene_manager.scene["map"]
        @theParty = $scene_manager.feature["party"]
        @bestiary = Bestiary.new()

        #Event choices and Windows
        @diffDialog = DialogBox.new(0,10,20,5,"ev0Dialog","Here's Johnny!! Have fun on map 2 with 300 more XP.")
        #@optionBox.hidden(true) 

        #--------------------Events--------------------------
        #registerEvent(eventName,imgName,eventX,eventY,bbWidth,bbHeight,columns,rows,mapNumber,bestiaryName,activateType,eventTriggered=->(){})

        #------ Teleport 101 (Door) Map02
        @map.registerEvent("Teleport101",:doors,21*32, 13*32,32,36,4,4,1,"god","SELECT",->(){$scene_manager.scene["map"].change_map("map02",15.5*32,18.5*32,"up")})
        $scene_manager.object["Teleport101"].set_animation(9)

        #------ Teleport 102 Map03
        $scene_manager.registerEvent(1,"Teleport102",
            Event.new(nil, ->(){
                $scene_manager.scene["map"].change_map("map03",15.5*32,27*32,"up")
        },@bestiary.enemy("god")))
        teleport2 = $scene_manager.event["Teleport102"]
        teleport2.activateType = "TOUCH"
        teleport2.x = 15.5*32
        teleport2.y = 0.5*32
    end

    def setMovement()
        player = $scene_manager.scene["player"]
        $scene_manager.event["Teleport101"].set_move("none")
        #$scene_manager.event["Teleport102"].set_move("none")
        
    end
    def draw
    end
    def update
        setMovement()
        @map.update()
        #$scene_manager.eventMap[1]
    end
end
