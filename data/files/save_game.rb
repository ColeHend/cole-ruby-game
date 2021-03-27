require 'json'
class SaveGame
    def initialize()
    end

    def writeSave(saveNum)
        @currentMap =  $scene_manager.scene["map"].currentMap.name
        @player = $scene_manager.scene["player"]
        @playerSave = {"player"=>[@currentMap,@player.x,@player.y]}

        @saveEvents = $scene_manager.event.map {|key,value|
                     {key=> [value.x,value.y]}
        }

        @party = $scene_manager.feature["party"]
        @partyStats = @party.party.map {|member|
            {member.name=>[member.hp,member.currentHP,member.exp]}
        }

        @playerSave.reduce(:merge)
        @partyStats.reduce(:merge)
        @saveEvents.reduce(:merge)
        @totalSave = Hash.new()
        @totalSave["events"] = @saveEvents
        @totalSave["player"] = @playerSave
        @totalSave["party"] = @partyStats
        
        puts("---------------------------------")
        puts(@totalSave["party"])
        puts("---------------------------------")

        puts("save Ran!")
        file = File.open("Saves/Save#{saveNum}.json", 'w')
        file.write(@totalSave.to_json)
        file.close 
    end

    def loadSave(saveNum)
        puts("load Ran!")
        if File.exists?("Saves/Save#{saveNum}.json") == true and File.empty?("Saves/Save#{saveNum}.json") == false
            
            doneYet = true
            if doneYet == true
                $scene_manager = SceneManager.new()
                File.open("Saves/Save#{saveNum}.json","r") do |file|
                    @saveFile = JSON.parse(file.read)
                end

                $scene_manager.register("title",TitleScreen.new())
                $scene_manager.register("gameover",Gameover.new())
                
                #--------------- Starting player stuff ---------------------------
                $scene_manager.registerFeature("party",PlayerParty.new) 

                @saveFile["party"].map do |value| # Adds the entire Party
                    value.map do |name,person|
                        personAdd = PlayerCharacter.new(name,person[0])
                        personAdd.give_xp(person[2])
                        personAdd.currentHP = person[1]
                        $scene_manager.feature["party"].addToParty(personAdd)
                    end
                     
                end

                $scene_manager.register("player",Player.new())  #change to add current player values
                $scene_manager.scene["player"].player.x = @saveFile["player"]["player"][1]
                $scene_manager.scene["player"].player.y = @saveFile["player"]["player"][2]
                $scene_manager.scene["player"].x = @saveFile["player"]["player"][1]
                $scene_manager.scene["player"].y = @saveFile["player"]["player"][2]
                #--------------- Done with player stuff --------------------------

                $scene_manager.register("map",SceneMap.new()) # set current map with this
                $scene_manager.scene["map"].currentMap = $scene_manager.scene["map"].mapHash[@saveFile["player"]["player"][0]]
                $scene_manager.register_object("fancyWindowSkin","fancyWindowSkin",0,0,0,0,6,4)
                $scene_manager.register_object("earthboundWindowSkin","earthboundWindowSkin",0,0,0,0,6,4)
                $scene_manager.register_object("blackWindowSkin","blackWindowSkin",0,0,0,0,6,4)
                $scene_manager.register_image("CastleTownTileset",:CastleTown,8,23)
                $scene_manager.images["windowSkin"] = $scene_manager.images["fancyWindowSkin"]
                $scene_manager.input.removeFromStack("optionsBox") # stack should be cleared need to ensure
                $scene_manager.register("menu",Menu.new())
                $scene_manager.input.addToStack("map")
                
                $scene_manager.switch_scene("map")
            end





            puts("loaded^")
        else
            puts("Save#{saveNum} failed to load!")
        end
    end

    def update
    end
    def draw
    end

end