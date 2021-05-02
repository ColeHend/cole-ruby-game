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
    attr_reader :name, :mapfile, :map , :events, :width, :height, :tileset,:bgm
    include WindowBase
    def initialize()
        #Variable Init
        @name = "map02"
        @mapfile = JSON.load(File.read("data/maps/map02.json"))
        @tileset = Tileset.new("CastleTown")
        @bgm = $scene_manager.songs['town']
        @width, @height = 30, 20
        @map = Mapper.new(@tileset,@width,@height,@mapfile)
        @events = $scene_manager.eventMap[2]
        
        @followDialog = DialogBox.new(0,10,20,5,"ev0SetMove","I LOVE YOU!! I'm going to follow you. Have 5000 XP.")
        @talkin = false
        @bestiary = Bestiary.new()

        #--------------------Events--------------------------
        #registerEvent(eventName,imgName,eventX,eventY,bbWidth,bbHeight,columns,rows,mapNumber,bestiaryName,activateType,eventTriggered=->(){})

        #------------------------WarpSquare--------------------------------
        $scene_manager.registerEvent(2,"Teleport201",
            Event.new(nil, ->(){
                $scene_manager.scene["map"].change_map("map01",21*32,14*32)
                
        },@bestiary.enemy("god")))
        teleport1 = $scene_manager.event["Teleport201"]
        teleport1.activateType = "TOUCH"
        teleport1.x = 14*32
        teleport1.y = 20*32
        #----------
        $scene_manager.registerEvent(2,"Teleport202",
            Event.new(nil, ->(){
                $scene_manager.scene["map"].change_map("map01",21*32,14*32)
        },@bestiary.enemy("god")))
        teleport2 = $scene_manager.event["Teleport202"]
        teleport2.activateType = "TOUCH"
        teleport2.x = 15*32
        teleport2.y = 20*32
        #-----------------------------------------------------------------
        @map.registerEvent("Event201","shadowGuy",6*32,5*32,32,48,4,4,2,"sandslash","SELECT",->(){
            $scene_manager.register("event201DialogBox",DialogBox.new(0,10,20,5,"Here have some experience!",->(){
                $scene_manager.feature["party"].party.each{|e| e.give_xp(500)}
            }))
            $scene_manager.switch_scene("event201DialogBox")
        })
        @map.registerEvent("Event202","lightCoat",15*32,10*32,30,47,4,4,2,"sandslash","SELECT",->(){
            $scene_manager.register("event202DialogBox",DialogBox.new(0,10,20,5,"Here heal!",->(){
                $scene_manager.feature["party"].party.each{|e| e.currentHP = e.hp}
            }))
            $scene_manager.switch_scene("event202DialogBox")
        })
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
        player = $scene_manager.scene["player"]
        event201 = $scene_manager.event["Event201"]
        event202 = $scene_manager.event["Event202"]
        if event201.battle.currentHP >= 0
            event201.set_move("followPlayer",10*32,1*32,player.eventObject)
        end
        if event202.battle.currentHP >= 0
            event202.set_move("followPlayer",10*32,1*32,player.eventObject)
        end
    end
end
