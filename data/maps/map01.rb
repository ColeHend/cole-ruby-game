require_relative "map.rb"
require_relative "scene_map.rb"
require_relative "tileset.rb"
require_relative "events/event.rb"
require_relative "events/event_trigger.rb"
require_relative "events/event_base.rb"
require_relative "../files/windowBase.rb"
require_relative "../files/optionsBox.rb"
require_relative "characters/character_player.rb"
require_relative "characters/enemy_bestiary.rb"
require_relative "characters/character_npc.rb"
require "json"

class Map01
    attr_reader :name, :map, :mapfile, :events, :width, :height, :tileset
    attr_accessor :bgm
    include WindowBase
    def initialize()
        # Initilize variables
        @name = "map01"
        @tileset = Tileset.new("CastleTownExterior",8,30)
        @mapfile = JSON.load(File.read("data/maps/map01.json"))
        @events = $scene_manager.eventMap[1]
        @bestiary = Bestiary.new()
        @eventBase = [
            Event_Base.new("Event101",:lightCoat,15*32,18*32,32,46,4,4,1,"god","SELECT"),
            Event_Base.new("Event102",:greenCoat,17*32,6*32,32,46,4,4,1,"god","SELECT"),
            Event_Base.new("Teleport101",:doors,21*32, 13*32,30,36,4,4,1,"god","SELECT"),
            Event.new(nil, ->(){$scene_manager.scene["map"].change_map("map03",15.5*32,27*32,"up")},@bestiary.enemy("god"))
        ]
        @mapDialog = Hash.new()
        #createDialog()
        @mapDialog["event101DialogBox"] = DialogBox.new(0,10,20,5, "Hello There Friend! Have Some Weapons And Armor!\nSpacebar to Interact with stuff! \nHit F for a Melee Attack, \nHit G for a Ranged Attack\nDon't forget to hit Escape to open the Menu and equip weapons and spells!",
         ->(){
            @inventory.add_weapon("ironMace")
            @inventory.add_weapon("ironSword")
            @inventory.add_weapon("fireBrand")
            @inventory.add_weapon("magicSlayer")
            @inventory.add_weapon("bronzeMace")
            @inventory.add_weapon("bronzeSword")
            @inventory.add_armor("leatherHelm")
            @inventory.add_armor("leatherArmor")
        })
        @mapDialog["event101DialogBox2"] = DialogBox.new(0,10,20,5,"Hello There Friend!\nHit Escape to open the Menu",->(){})
        @mapDialog["event102DialogBox"] = DialogBox.new(0,10,20,5,"Hello There Friend!Have Some potions!\nHit Escape to open the Menu",->(){
            @inventory.add_item("potion")
            @inventory.add_item("potion")
            @inventory.add_item("potion")
        })
        @mapDialog["event102DialogBox2"] = DialogBox.new(0,10,20,5,"I Think i like you!Have Some Mega potions!",->(){
            @inventory.add_item("megaPotion")
            @inventory.add_item("megaPotion")
            @inventory.add_item("megaPotion")
        })
        @mapDialog["event102DialogBox3"] = DialogBox.new(0,10,20,5,"Here have a potion.",->(){@inventory.add_item("potion")})
        #-----
        $scene_manager.register_song("serious","serious",".ogg")
        $scene_manager.register_song("town","town",".ogg")
        $scene_manager.register_sound("select","select",".ogg")
        $scene_manager.register_sound("sword","sword",".ogg")
        $scene_manager.register_sound("explosion","explosion",".ogg")
        $scene_manager.register_sound("youLose","youLose",".ogg")
        @bgm = $scene_manager.songs['town']
        @map = Mapper.new(@tileset,30,20,@mapfile)
        @width = 30
        @height = 20
        @curEvnt = false
        @sceneMap = $scene_manager.scene["map"]
        @theParty = $scene_manager.feature["party"]
        @inventory = $scene_manager.feature["party"].inventory
        #Event choices and Windows
        @diffDialog = DialogBox.new(0,10,20,5,"ev0Dialog","Here's Johnny!! Have fun on map 2 with 300 more XP.")
        #@optionBox.hidden(true)
        
        #createEvents()
        #--------------------Events--------------------------
        #registerEvent(eventName,imgName,eventX,eventY,bbWidth,bbHeight,columns,rows,mapNumber,bestiaryName,activateType,eventTriggered=->(){})
        #----- Event 101 -----
        @map.registerEvent(@eventBase[0],->(){
            event101 = $scene_manager.event["Event101"]
            if event101.page == 1
                $scene_manager.register("event101DialogBox",@mapDialog["event101DialogBox"])
                $scene_manager.switch_scene("event101DialogBox")
                event101.page = 2
            elsif event101.page == 2
                $scene_manager.register("event101DialogBox2",@mapDialog["event101DialogBox2"])
                $scene_manager.switch_scene("event101DialogBox2")
            end
            
        })
        $scene_manager.object["Event101"].set_animation(12)
        #----- Event 102 -----  
        @map.registerEvent(@eventBase[1],->(){
            event102 = $scene_manager.event["Event102"]
            if event102.page == 1
                $scene_manager.register("event102DialogBox",@mapDialog["event102DialogBox"])
                $scene_manager.switch_scene("event102DialogBox")
                event102.page = 2
            elsif event102.page == 2
                $scene_manager.register("event102DialogBox",@mapDialog["event102DialogBox2"])
                $scene_manager.switch_scene("event102DialogBox")
                event102.page = 3
            elsif event102.page == 3
                $scene_manager.register("event102DialogBox",@mapDialog["event102DialogBox3"])
                $scene_manager.switch_scene("event102DialogBox")
            end
        })
        
        $scene_manager.object["Event102"].set_animation(4)
        #------ Teleport 101 (Door) Map02
        @map.registerEvent(@eventBase[2],->(){$scene_manager.scene["map"].change_map("map02",15.5*32,18.5*32,"up")})
        $scene_manager.object["Teleport101"].set_animation(9)

        #------ Teleport 102 Map03 
        $scene_manager.registerEvent(1,"Teleport102",@eventBase[3])
        teleport2 = $scene_manager.event["Teleport102"]
        teleport2.activateType = "TOUCH"
        teleport2.x = 15.5*32
        teleport2.y = 0.5*32
    end
    
    def setMovement()
        player = $scene_manager.scene["player"]
        event101 = $scene_manager.event["Event101"] #lightCoat
        event102 = $scene_manager.event["Event102"] #greenCoat 
        $scene_manager.event["Teleport101"].set_move("none")
        if event101.page == 1
            event101.set_move("followPlayer",10*32,player.eventObject)
            event101.activateType = "TOUCH"
        else
            event101.activateType = "SELECT"
            event101.set_move("random",4*32) 
        end
        event102.set_move("random",2*32) 
        
        
    end
    def draw
    end
    def update
        setMovement()
        @map.update()
        #$scene_manager.eventMap[1]
    end
end
