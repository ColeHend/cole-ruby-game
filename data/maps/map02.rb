require_relative "map.rb"
require_relative "scene_map.rb"
require_relative "events/event.rb"
require_relative "events/event_trigger.rb"
require_relative "../files/windowBase.rb"
require_relative "../files/dialogBox.rb"
require_relative "characters/inventory.rb"
require "json"
class Map02 < Map
    attr_reader :mapfile, :map , :events, :width, :height
    include WindowBase
    def initialize()
        #Variable Init
        @mapfile = JSON.load(File.read("data/maps/map02.json"))
        @tileset = $scene_manager.images["CastleTownTileset"]
        @map = Mapper.new(@tileset,40,30,@mapfile)
        @events = $scene_manager.eventMap[2]
        @width, @height = 40, 30
        @followDialog = DialogBox.new(0,10,20,5,"ev0SetMove","I LOVE YOU!! I'm going to follow you. Have 5000 XP.")
        @talkin = false

        #Events
        $scene_manager.register_object("Event201","shadowGuy",6*32,5*32,32,48,4,4)
        $scene_manager.register_object("Event202","lightCoat",15*32,10*32,32,48,4,4)
        $scene_manager.registerEvent(2,"john1",
            Event.new($scene_manager.object["Event201"], EventTrigger::ACTION_KEY, true, ->(){
                #@talkin = true
                #$scene_manager.input.addToStack(@followDialog.stackName)
                $scene_manager.feature["party"].party.each{|e| e.give_xp(5000)}
                @events[0].set_move("followPlayer",2)
                @events[1].set_move("random",1)
                puts("_____________Inventory_________________")
                $scene_manager.feature["party"].inventory.each{|e| puts(e.name)}
                puts("_______________________________________")
        }))

        $scene_manager.registerEvent(2,"john2",
            Event.new($scene_manager.object["Event202"], EventTrigger::ACTION_KEY, true, ->(){
                $scene_manager.scene["map"].change_map("map1")
            })
        )
        
    end

    def draw()
        #@map.draw()
        #$scene_manager.eventMap[2].each {|e|e.draw()}
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
        #$scene_manager.eventMap[1].each {|e|@map.collision[e.x][e.y] = 1}
    end
end
