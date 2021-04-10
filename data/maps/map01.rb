require_relative "map.rb"
require_relative "scene_map.rb"
require_relative "events/event.rb"
require_relative "events/event_trigger.rb"
require_relative "../files/windowBase.rb"
require_relative "../files/optionsBox.rb"
require_relative "characters/character_player.rb"
require_relative "characters/enemy_bestiary.rb"
require_relative "characters/character_npc.rb"
require "json"

class Map01
    attr_reader :name, :map, :mapfile, :events, :width, :height
    include WindowBase
    def initialize()
        # Initilize variables
        @name = "map01"
        @talkin = false
        @tileset = $scene_manager.images["CastleTownTileset"]
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
        @showChoices = false
        @showSkinChoices = false
        @windowSkinChoice = [
            Option.new("FancySkin",->(){$scene_manager.images["windowSkin"] = $scene_manager.images["fancyWindowSkin"] }),
            Option.new("BlackSkin",->(){$scene_manager.images["windowSkin"] = $scene_manager.images["blackWindowSkin"]}),
            Option.new("EarthboundSkin",->(){$scene_manager.images["windowSkin"] = $scene_manager.images["earthboundWindowSkin"]}),
            Option.new("Back",->(){$scene_manager.input.removeFromStack(@windowSkinBox.stackName)
                @showSkinChoices = false})
        ]
        @choice = [Option.new("Change WindowSkin",->(){
                $scene_manager.input.addToStack(@windowSkinBox.stackName)
                @showSkinChoices = true
            }),Option.new("Title Screen",->(){
                $scene_manager.input.removeFromStack("evntOneOptions")
                $scene_manager.input.removeFromStack("map")
                $scene_manager.input.addToStack("optionsBox")
                $scene_manager.switch_scene("title") }),
               Option.new("Exit",->(){
                   @showChoices = false
                    $scene_manager.input.removeFromStack("evntOneOptions")
                    $scene_manager.input.addToStack("map")
                }) 
            ]
        @optionsBox = OptionsBox.new("evntOneOptions",3,8,5,2,@choice,"")
        @windowSkinBox = OptionsBox.new("windowSkinOptions",9,8,5,2,@windowSkinChoice,"")
        #@optionBox.hidden(true) 

        #   -----Events-----
        #------------------------WarpSquare--------------------------------
        
        $scene_manager.registerEvent(1,"Teleport101",
            Event.new(nil, ->(){
                $scene_manager.scene["map"].change_map("map02")
                $scene_manager.object["player"].y += 32
                
        },@bestiary.enemy("god")))
        @teleport1 = $scene_manager.event["Teleport101"]
        @teleport1.activateType = "TOUCH"
        @teleport1.x = 12*32
        @teleport1.y = 16
        
        $scene_manager.registerEvent(1,"Teleport102",
            Event.new(nil, ->(){
                $scene_manager.scene["map"].change_map("map02")
                $scene_manager.object["player"].y += 32
        },@bestiary.enemy("god")))
        @teleport2 = $scene_manager.event["Teleport102"]
        @teleport2.activateType = "TOUCH"
        @teleport2.x = 13*32
        @teleport2.y = 16
        #-----------------------------------------------------------------
        # Event 101
        $scene_manager.register_object("Event101","greenMan",7*32,10*32,30,46,4,4)
        $scene_manager.registerEvent(1,"Event101",
            Event.new($scene_manager.object["Event101"], ->(){
                #$scene_manager.input.addToStack("ev0Dialog")
                @talkin = true
                $scene_manager.feature["party"].addToParty(NpcCharacter.new("Johnny",5))
                $scene_manager.feature["party"].party[0].level_up
                
        },@bestiary.enemy("goblin")))

        # Event 102
        $scene_manager.register_object("Event102","ghost",5*32,5*32,30,48,4,4)
        $scene_manager.registerEvent(1,"Event102",
            Event.new($scene_manager.object["Event102"], ->(){
                if @showChoices == false
                    #$scene_manager.input.removeFromStack(@optionsBox.stackName)
                    $scene_manager.input.addToStack(@optionsBox.stackName)
                    @showChoices = true
                else
                    #@optionBox.hidden = true
                end
        },@bestiary.enemy("ghost")))
        
    end
    def draw
        if @showChoices
            @optionsBox.draw
        end
        if @showSkinChoices
            @windowSkinBox.draw
        end
        if @talkin
            @diffDialog.draw_box(->(){@talkin = false
                $scene_manager.input.removeFromStack(@diffDialog.stackName)
                $scene_manager.input.addToStack("map")
                $scene_manager.scene["map"].change_map("map02")})
        end
    end
    def update
        $scene_manager.event["Teleport101"].x, $scene_manager.event["Teleport101"].y = 12*32, 16
        $scene_manager.event["Teleport102"].x, $scene_manager.event["Teleport102"].y = 13*32, 16
        
        $scene_manager.event["Teleport101"].set_move("none")
        $scene_manager.event["Teleport102"].set_move("none")
        $scene_manager.event["Event102"].set_move("followPlayer",10*32,4*32,"ranged",$scene_manager.scene["player"]) #ghost
        $scene_manager.event["Event101"].set_move("followPlayer",10*32,2*32,"melee",$scene_manager.scene["player"]) #greenguy
        @map.update()
        #$scene_manager.eventMap[1]
        if @showChoices == true
            @optionsBox.update()
        end
            
        if @showSkinChoices
            @windowSkinBox.update
        end
    end
end
