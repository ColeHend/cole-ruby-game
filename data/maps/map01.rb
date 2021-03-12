require_relative "map.rb"
require_relative "scene_map.rb"
require_relative "events/event.rb"
require_relative "events/event_trigger.rb"
require_relative "../files/windowBase.rb"
require_relative "../files/optionsBox.rb"
require_relative "characters/character_player.rb"
require "json"

class Map01
    attr_reader :map, :mapfile, :events, :width, :height
    include WindowBase
    def initialize()
        @talkin = false
        @mapfile = JSON.load(File.read("data/maps/map01.json"))
        @map = Map.new("data/images/CastleTown.bmp",40,30,@mapfile)
        @width = 40
        @height = 30
        @curEvnt = false
        @sceneMap = $scene_manager.scene["map"]
        @theParty = $scene_manager.feature["party"]
        @diffDialog = DialogBox.new(0,10,20,5,"ev0Dialog","Here's Johnny!! Have fun on map 2 with 300 more XP.")
        
        @showSkinChoices = false
        @windowSkinChoice = [
            Option.new("FancySkin",->(){$scene_manager.images["windowSkin"] = $scene_manager.images["fancyWindowSkin"] }),
            Option.new("BlackSkin",->(){$scene_manager.images["windowSkin"] = $scene_manager.images["blackWindowSkin"]}),
            Option.new("EarthboundSkin",->(){$scene_manager.images["windowSkin"] = $scene_manager.images["earthboundWindowSkin"]}),
            Option.new("Back",->(){$scene_manager.input.removeFromStack("windowSkinOptions")
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
               Option.new("Exit",->(){@optionBox.hidden(true)
                $scene_manager.input.removeFromStack("evntOneOptions")
                #$scene_manager.input.addToStack("map")
                
                
                }) 
            ]
        @optionsBox = OptionsBox.new("evntOneOptions",3,8,5,2,@choice,"")
        @windowSkinBox = OptionsBox.new("windowSkinOptions",9,8,5,2,@windowSkinChoice,"")
        #@optionBox.hidden(true)
        greenGuySprite = Gosu::Image.load_tiles("data/images/greenMan.bmp", 32, 48) 
        ghostSprite = Gosu::Image.load_tiles("data/images/ghost.bmp", 32, 48) 
        sameGuySprite = Gosu::Image.load_tiles("data/images/untitled.bmp", 32, 48) 
        sameGuySprite = Gosu::Image.load_tiles("data/images/untitled.bmp", 32, 48)

        $scene_manager.registerEvent(1,"fred1",
            Event.new(greenGuySprite, 7, 10, EventTrigger::ACTION_KEY, true, ->(){
                $scene_manager.input.addToStack("ev0Dialog")
                @talkin = true
                $scene_manager.feature["party"].addToParty(PlayerCharacter.new("Johnny",5))
                $scene_manager.feature["party"].party[0].give_xp(300)
                $scene_manager.feature["party"].inventory.push(Inventory.new.items["potion"])
                $scene_manager.feature["party"].inventory.push(Inventory.new.items["poison"])
                # @events[0].set_move("random",1)
                # @events[1].set_move("followPlayer",2)
        }))

        $scene_manager.registerEvent(1,"fred2",
            Event.new(ghostSprite, 5, 5, EventTrigger::ACTION_KEY, true, ->(){
                if !@showChoices 
                    #$scene_manager.input.removeFromStack(@optionsBox.stackName)
                    $scene_manager.input.addToStack(@optionsBox.stackName)
                    @optionBox.hidden(false)
                else
                    @optionBox.hidden(true)
                end
        }))

        @events = $scene_manager.eventMap[1] 
    end
    def draw
        @map.draw(@events)
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
                $scene_manager.scene["map"].change_map("map2")})
        end
    end
    def update
        @events.each {|e| @map.collision[e.x][e.y] = 1}
        @map.update()
        if @showChoices
            @optionsBox.update
        end
        if @showSkinChoices
            @windowSkinBox.update
        end
    end
end
