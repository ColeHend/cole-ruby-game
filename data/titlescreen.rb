
class TitleScreen
    def initialize()
        @gameName = Gosu::Image.from_text("The Game", 30)
        @instructions = Gosu::Image.from_text("Press space to continue", 20)
        @input = $scene_manager.input
        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000)
        @choice = [Option.new("New Game",->(){
            $scene_manager = SceneManager.new()
            $scene_manager.register("title",TitleScreen.new())
            $scene_manager.register("gameover",Gameover.new())
            $scene_manager.registerFeature("party",PlayerParty.new)
             # change to make player an event instead
            $scene_manager.register("map",SceneMap.new())
            $scene_manager.register_object("fancyWindowSkin","fancyWindowSkin",0,0,0,0,6,4)
            $scene_manager.register_object("earthboundWindowSkin","earthboundWindowSkin",0,0,0,0,6,4)
            $scene_manager.register_object("blackWindowSkin","blackWindowSkin",0,0,0,0,6,4)
            #---------Register Player
            playerObj = $scene_manager.register_object("player",:player,6*32,18*32,31,47,4,4)
            fredObj = $scene_manager.register_object("player",:greenCoat,4*32,18*32,31,47,4,4)
            $scene_manager.register("player",Event.new(playerObj, ->(){},PartyCollection.new.party("Steve")))
            $scene_manager.feature["party"].addToParty($scene_manager.scene["player"])
            $scene_manager.feature["party"].addToParty(Event.new(fredObj, ->(){},PartyCollection.new.party("Fred")))
            
            #----------------------
            $scene_manager.register_image("CastleTownTileset",:CastleTown,8,23)
            $scene_manager.images["windowSkin"] = $scene_manager.images["fancyWindowSkin"]
            $scene_manager.input.removeFromStack("optionsBox")
            
            $scene_manager.register("menu",Menu.new())
            $scene_manager.register("equipMenu",EquipMenu.new())
            $scene_manager.input.addToStack("map")
            $scene_manager.scene["player"].set_move("player")
             
            $scene_manager.event["Event102"].randomTime = Gosu::milliseconds()
            $scene_manager.switch_scene("map")
        }),
            Option.new("Load",->(){SaveGame.new().loadSave(1)}),
            Option.new("Exit",->(){$window.close()})]
        @optionsBox = OptionsBox.new("optionsBox",8,8,3,2,@choice,"")
        #@optionsBox.currentColor = Gosu::Color.argb(0xff_2ca81e)
    end

    def update()
        @optionsBox.update
        
    end

    def draw()
        @gameName.draw(240, 40, 5,scale_x = 1, scale_y = 1, color = @white)
        @instructions.draw(220, 70, 5,scale_x = 1, scale_y = 1, color = @white)
        @optionsBox.draw
    end

end