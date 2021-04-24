require 'json'
class SaveGame
    def initialize()
    end

    def writeSave(saveNum)
        @currentMap =  $scene_manager.scene["map"].currentMap.name
        @player = $scene_manager.scene["player"]

        #player save
        @playerSave = {"player"=>[@currentMap,@player.x,@player.y]} 

         #event save
        @saveEvents = $scene_manager.event.map {|key,value|
                     {key=> [value.x,value.y,value.battle.currentHP]}
        }

        #player party save
        @party = $scene_manager.feature["party"]
        @partyStats = @party.party.map {|member| 
            {member.name=>[member.hp,member.currentHP,member.exp]}
        }
        #inventory save
        @inventory = @party.inventory
        @saveItems = @inventory.items.map {|item|
            {item.name=>[item.used]}
        }
        @saveWeapons = @inventory.weapons.map {|weapon|
            {weapon.name=>[weapon.damage,weapon.animation]}
        }
        @saveArmor = @inventory.armor.map {|armor|
            {armor.name=>[armor.type,armor.armor]}
        }
        @saveItems.reduce(:merge)
        @saveWeapons.reduce(:merge)
        @saveArmor.reduce(:merge)
        @playerSave.reduce(:merge)
        @partyStats.reduce(:merge)
        @saveEvents.reduce(:merge)
        @totalSave = Hash.new()
        @totalSave["events"] = @saveEvents
        @totalSave["player"] = @playerSave
        @totalSave["party"] = @partyStats
        @totalSave["items"] = @saveItems
        @totalSave["weapons"] = @saveWeapons
        @totalSave["armor"] = @saveArmor
        puts("---------------------------------")
        puts(@totalSave["weapons"])
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

                playerObj = $scene_manager.register_object("player",:player,6*32,6*32,31,47,4,4)
                $scene_manager.register("player",Event.new(playerObj, ->(){},$scene_manager.feature["party"].party[0]))  #change to add current player values
                $scene_manager.scene["player"].eventObject.x = @saveFile["player"]["player"][1]
                $scene_manager.scene["player"].eventObject.y = @saveFile["player"]["player"][2]
                $scene_manager.scene["player"].x = @saveFile["player"]["player"][1]
                $scene_manager.scene["player"].y = @saveFile["player"]["player"][2]
                #--------------- Done with player stuff --------------------------
                
                $scene_manager.register("map",SceneMap.new())
                $scene_manager.register_object("fancyWindowSkin","fancyWindowSkin",0,0,0,0,6,4)
                $scene_manager.register_object("earthboundWindowSkin","earthboundWindowSkin",0,0,0,0,6,4)
                $scene_manager.register_object("blackWindowSkin","blackWindowSkin",0,0,0,0,6,4)
                $scene_manager.scene["map"].change_map(@saveFile["player"]["player"][0])
                $scene_manager.register_image("CastleTownTileset",:CastleTown,8,23)
                $scene_manager.images["windowSkin"] = $scene_manager.images["fancyWindowSkin"]
                $scene_manager.input.removeFromStack("optionsBox")
                
                #$scene_manager.event

                $scene_manager.register("menu",Menu.new())
                $scene_manager.register("equipMenu",EquipMenu.new())
                $scene_manager.input.addToStack("map")
                $scene_manager.scene["player"].set_move("player")
                $scene_manager.switch_scene("map")
                
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