
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
            $scene_manager.feature["party"].addToParty(PlayerCharacter.new("Steve",30.0))
             # change to make player an event instead
            $scene_manager.register("map",SceneMap.new())
            
            $scene_manager.register_object("fancyWindowSkin","fancyWindowSkin",0,0,0,0,6,4)
            $scene_manager.register_object("earthboundWindowSkin","earthboundWindowSkin",0,0,0,0,6,4)
            $scene_manager.register_object("blackWindowSkin","blackWindowSkin",0,0,0,0,6,4)
            playerObj = $scene_manager.register_object("player",:player,6*32,6*32,31,47,4,4)
            $scene_manager.register("player",Event.new(playerObj, ->(){},$scene_manager.feature["party"].party[0]))
            $scene_manager.register_image("CastleTownTileset",:CastleTown,8,23)
            $scene_manager.images["windowSkin"] = $scene_manager.images["fancyWindowSkin"]
            $scene_manager.input.removeFromStack("optionsBox")
            
            #$scene_manager.feature["party"].inventory.push(Inventory.new.items["poison"])
            #$scene_manager.feature["party"].inventory.push(Inventory.new.items["potion"])
            $scene_manager.register("menu",Menu.new())
            $scene_manager.input.addToStack("map")
            $scene_manager.scene["player"].set_move("player")
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