require_relative "map.rb"
require_relative "scene_map.rb"
require_relative "events/event.rb"
require_relative "events/event_trigger.rb"
require_relative "characters/enemy_bestiary.rb"
require_relative "../files/windowBase.rb"
require_relative "../files/dialogBox.rb"
require_relative "characters/inventory.rb"
require_relative "characters/character_npc.rb"
require "json"
class Map02 < Map
    attr_reader :name, :mapfile, :map , :events, :width, :height
    include WindowBase
    def initialize()
        #Variable Init
        @name = "map02"
        @mapfile = JSON.load(File.read("data/maps/map02.json"))
        @tileset = $scene_manager.images["CastleTownTileset"]
        @width, @height = 30, 20
        @map = Mapper.new(@tileset,@width,@height,@mapfile)
        @events = $scene_manager.eventMap[2]
        
        @followDialog = DialogBox.new(0,10,20,5,"ev0SetMove","I LOVE YOU!! I'm going to follow you. Have 5000 XP.")
        @talkin = false
        @bestiary = Bestiary.new()
        #Events
        #------------------------WarpSquare--------------------------------
        teleport1 = $scene_manager.registerEvent(2,"Teleport201",
            Event.new(nil, EventTrigger::ACTION_KEY, true, ->(){
                $scene_manager.scene["map"].change_map("map01")
                $scene_manager.object["player"].y += 32
                
        },@bestiary.enemy("god")))
        teleport1[0].activateType = "TOUCH"
        teleport1[0].x = 12*32
        teleport1[0].y = 16
        teleport2 = $scene_manager.registerEvent(2,"Teleport202",
            Event.new(nil, EventTrigger::ACTION_KEY, true, ->(){
                $scene_manager.scene["map"].change_map("map01")
                $scene_manager.object["player"].y += 32
        },@bestiary.enemy("god")))
        teleport2[0].activateType = "TOUCH"
        teleport2[0].x = 13*32
        teleport2[0].y = 16
        #-----------------------------------------------------------------
        $scene_manager.register_object("Event201","shadowGuy",6*32,5*32,32,48,4,4)
        $scene_manager.register_object("Event202","lightCoat",15*32,10*32,32,48,4,4)
        $scene_manager.registerEvent(2,"Event201",
            Event.new($scene_manager.object["Event201"], EventTrigger::ACTION_KEY, true, ->(){
                #@talkin = true
                #$scene_manager.input.addToStack(@followDialog.stackName)
                $scene_manager.feature["party"].party.each{|e| e.give_xp(5000)}
                @events[0].set_move("followPlayer")
                @events[1].set_move("random")
        },@bestiary.enemy("goblin")
        ))

        $scene_manager.registerEvent(2,"Event202",
            Event.new($scene_manager.object["Event202"], EventTrigger::ACTION_KEY, true, ->(){
            },@bestiary.enemy("god")
            ))
        
            
            
    end

    def draw()
        #@map.draw()
        
        if @talkin
            @followDialog.draw_box(->(){
                @talkin = false
                $scene_manager.input.removeFromStack(@followDialog.stackName)
                $scene_manager.input.addToStack("map")
        })
        end
    end

    def update()
        @map.update()
        $scene_manager.event["Event201"].set_move("followPlayer",10*32,1*32,"melee",$scene_manager.scene["player"])
        $scene_manager.event["Event202"].set_move("followPlayer",10*32,1*32,"melee",$scene_manager.scene["player"])
    end
end
