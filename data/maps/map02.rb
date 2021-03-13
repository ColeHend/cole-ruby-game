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
        @mapfile = JSON.load(File.read("data/maps/map02.json"))
        @tileset = $scene_manager.images["CastleTownTileset"]
        @map = Mapper.new(@tileset,40,30,@mapfile)
        
        @width, @height = 40, 30
        @followDialog = DialogBox.new(0,10,20,5,"ev0SetMove","I LOVE YOU!! I'm going to follow you. Have 5000 XP.")
        @talkin = false
        $scene_manager.register_object("Event201","shadowGuy",6*32,5*32,32,48,4,4)
        $scene_manager.register_object("Event202","lightCoat",15*32,10*32,32,48,4,4)
        $scene_manager.registerEvent(2,"john1",
            Event.new($scene_manager.object["Event201"], EventTrigger::ACTION_KEY, true, ->(){
                @talkin = true
                $scene_manager.input.addToStack(@followDialog.stackName)
                $scene_manager.feature["party"].inventory.push(Inventory.new.items["potion"])
                $scene_manager.feature["party"].inventory.push(Inventory.new.items["poison"])
                $scene_manager.feature["party"].party.each{|e| e.give_xp(5000)}
                @events[0].set_move("followPlayer",2)
                @events[1].set_move("random",1)
                $scene_manager.feature["party"].use_item(0,$scene_manager.feature["party"].party[0])
                puts("_____________Inventory_________________")
                $scene_manager.feature["party"].inventory.each{|e| puts(e.name)}
                puts("_______________________________________")
        }))

        $scene_manager.registerEvent(2,"john2",
            Event.new($scene_manager.object["Event202"], EventTrigger::ACTION_KEY, true, ->(){
                $scene_manager.scene["map"].change_map("map1")
            })
        )
        @events = $scene_manager.eventMap[2]
        
    end
    def draw()
        @map.draw()
        $scene_manager.eventMap[2].each {|e|e.draw(@theMap)}
        if @talkin
            @followDialog.draw_box(->(){@talkin = false})
        end
    end
    def update()
        @events.each {|e| @map.collision[e.x][e.y] = 1}
        @map.update()
    end
end
