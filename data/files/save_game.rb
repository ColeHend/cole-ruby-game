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
                     {key=> [value.x,value.y,value.battle.currentHP,value.page]}
        }

        #player party save
        @party = $scene_manager.feature["party"]
        @partyStats = @party.party.map {|member| 
            {member.name=>[
                member.hp,member.currentHP,member.exp,
                if member.weapon == 666
                    member.weapon
                else
                    member.weapon.codeName
                end, 
                if member.shield == 666
                    member.shield
                else
                    member.shield.codeName
                end,
                if member.helm == 666
                    member.helm
                else
                    member.helm.codeName
                end, 
                if member.necklace == 666
                    member.necklace
                else
                    member.necklace.codeName
                end,
                if member.chest == 666
                    member.chest
                else
                    member.chest.codeName
                end, 
                if member.hands == 666
                    member.hands
                else
                    member.hands.codeName
                end,
                if member.legs == 666
                    member.legs
                else
                    member.legs.codeName
                end, 
                if member.feet == 666
                    member.feet
                else
                    member.feet.codeName
                end
            ]}#shield,helm,necklace,chest,hands, legs, feet
        }
        #inventory save
        @inventory = @party.inventory
        @saveItems = @inventory.items.map {|item|
            {item.codeName=>[item.used]}
        }
        @saveWeapons = @inventory.weapons.map {|weapon|
            {weapon.codeName=>[weapon.animation]}
        }
        @saveArmor = @inventory.armor.map {|armor|
        if armor != 666 && armor != nil
            {armor.codeName=>[armor.type,armor.armor]}
        end
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
                $scene_manager.feature["party"].party.each{|partyMember|
                    @saveFile["party"].each{|memberHash|
                        memberHashNames = memberHash.keys[0]
                        if  memberHashNames == partyMember.name
                            puts(memberHashNames)
                            partyMember.hp = @saveFile["party"][0][memberHashNames][0].to_i
                            partyMember.currentHP = @saveFile["party"][0][memberHashNames][1].to_i

                            partyMember.exp = @saveFile["party"][0][memberHashNames][2].to_i

                            takeTheArmor = ->(name){$scene_manager.feature["party"].inventory.takeArmor(name)}
                            if partyMember.weapon.name != @saveFile["party"][0][memberHashNames][3]
                                puts(@saveFile["party"][0][memberHashNames][3])
                                partyMember.weapon = $scene_manager.feature["party"].inventory.takeWeapon(@saveFile["party"][0][memberHashNames][3])
                            end

                            if @saveFile["party"][0][memberHashNames][4].is_a?(String) == false
                                partyMember.shield = nil
                            elsif partyMember.shield.name != @saveFile["party"][0][memberHashNames][4]
                                partyMember.shield = takeTheArmor.call(@saveFile["party"][0][memberHashNames][4])
                            end
                            if @saveFile["party"][0][memberHashNames][5].is_a?(String) == false
                                partyMember.helm = nil
                            elsif partyMember.helm.name != @saveFile["party"][0][memberHashNames][5]
                                partyMember.helm = takeTheArmor.call(@saveFile["party"][0][memberHashNames][5])
                            end
                            if @saveFile["party"][0][memberHashNames][6].is_a?(String) == false
                                partyMember.necklace = nil
                            elsif partyMember.necklace.name != @saveFile["party"][0][memberHashNames][6]
                                partyMember.necklace = takeTheArmor.call(@saveFile["party"][0][memberHashNames][6])
                            end
                            if @saveFile["party"][0][memberHashNames][7].is_a?(String) == false
                                partyMember.chest = nil
                            elsif partyMember.chest.name != @saveFile["party"][0][memberHashNames][7]
                                partyMember.chest = takeTheArmor.call(@saveFile["party"][0][memberHashNames][7])
                            end
                            if @saveFile["party"][0][memberHashNames][8].is_a?(String) == false
                                partyMember.hands = nil
                            elsif partyMember.hands.name != @saveFile["party"][0][memberHashNames][8]
                                partyMember.hands = takeTheArmor.call(@saveFile["party"][0][memberHashNames][8])
                            end
                            if @saveFile["party"][0][memberHashNames][9].is_a?(String) == false
                                partyMember.legs = nil
                            elsif partyMember.legs.name != @saveFile["party"][0][memberHashNames][9]
                                partyMember.legs = takeTheArmor.call(@saveFile["party"][0][memberHashNames][9])
                            end
                            if @saveFile["party"][0][memberHashNames][10].is_a?(String) == false
                                partyMember.feet = nil
                            elsif partyMember.feet.name != @saveFile["party"][0][memberHashNames][10]
                                partyMember.feet = takeTheArmor.call(@saveFile["party"][0][memberHashNames][10])
                            end
                        end
                    }#[member.hp,member.currentHP,member.exp,member.weapon.name,member.shield.name,member.helm.name,member.necklace.name,member.chest.name,member.hands.name,member.legs.name,member.feet.name]
                }
                
                $scene_manager.scene["player"].eventObject.x = @saveFile["player"]["player"][1]
                $scene_manager.scene["player"].eventObject.y = @saveFile["player"]["player"][2]
                $scene_manager.scene["player"].x = @saveFile["player"]["player"][1]
                $scene_manager.scene["player"].y = @saveFile["player"]["player"][2]
                #--------------- Done with player stuff --------------------------
                

                $scene_manager.register("map",SceneMap.new())
                $scene_manager.register_object("fancyWindowSkin","fancyWindowSkin",0,0,0,0,6,4)
                $scene_manager.register_object("earthboundWindowSkin","earthboundWindowSkin",0,0,0,0,6,4)
                $scene_manager.register_object("blackWindowSkin","blackWindowSkin",0,0,0,0,6,4)
                $scene_manager.scene["map"].change_map(@saveFile["player"]["player"][0],@saveFile["player"]["player"][1],@saveFile["player"]["player"][2])
                $scene_manager.register_image("CastleTownTileset",:CastleTown,8,23)
                $scene_manager.images["windowSkin"] = $scene_manager.images["fancyWindowSkin"]
                $scene_manager.input.removeFromStack("optionsBox")
                
                $scene_manager.eventMap.map{|eventmaps| #load events
                    eventmaps.each {|event|
                    name = event.name
                    @saveFile["events"].each{|e|
                            if event.name == e.keys[0]
                                event.x = e[event.name][0]
                                event.y = e[event.name][1]
                                event.page = e[event.name][3]
                                if event.eventObject != nil
                                    event.eventObject.x = e[event.name][0]
                                    event.eventObject.y = e[event.name][1]
                                end
                            end
                        }
                    
                    }
                }
                if  @saveFile["items"].length > 0
                    @saveFile["items"].each{|itemHash|
                        if itemHash.keys[0].is_a?(String) == true
                            $scene_manager.feature["party"].inventory.add_item(itemHash.keys[0])
                        end
                    }
                end
                if  @saveFile["weapons"].length > 0
                    @saveFile["weapons"].each{|weaponHash|
                        if weaponHash.keys[0].is_a?(String) == true
                            $scene_manager.feature["party"].inventory.add_weapon(weaponHash.keys[0])
                        end
                    }
                end
                if  @saveFile["armor"].length > 0
                    @saveFile["armor"].each{|armorHash|
                        if armorHash.keys[0].is_a?(String) == true
                            $scene_manager.feature["party"].inventory.add_armor(armorHash.keys[0])
                        end
                    }
                end
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