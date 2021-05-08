require_relative "input_trigger.rb"
require_relative "option.rb"
require_relative "optionsBox.rb"
require_relative "windowBase.rb"
require_relative "save_game.rb"
class Menu
    include WindowBase
    def initialize()
        @input = $scene_manager.input
        @optionsBoxHeightMod = 0
        @player = $scene_manager.scene["player"]
        @party = $scene_manager.feature["party"]
        @deathCap = @party.maxPartySize
        @deathTotal = @party.deathTotal
        @party = $scene_manager.feature["party"].party
        @cooldownTime = Gosu::milliseconds
        # Colors
        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000)
        @orange = Gosu::Color.argb(0xff_fc5203)
        @brightGreen = Gosu::Color.argb(0xff_2ca81e)
        #Party Info Text
        @partyNames = @party.map{|e|Gosu::Image.from_text(e.name, 25)}
        @partyHP = @party.map{|e|Gosu::Image.from_text("HP: "+e.hp.to_s+"/"+e.currentHP.to_s, 18)}
        @partyLVL = @party.map{|e|Gosu::Image.from_text("Level: "+e.playerLevel.to_s, 18)}
        @partyXP = @party.map{|e|Gosu::Image.from_text("XP: "+e.exp.to_s, 18)}
        #Items
        @currentItemOp = 0 
        @notCurrentColor = @white
        @currentColor = @brightGreen
        @colors = Array.new(40,@notCurrentColor)
        @colors[0] = @currentColor

        #Options and Boxes
        @options = [   
            Option.new("Items",->(){
                $scene_manager.register("itemMenu",ItemMenu.new())
                $scene_manager.switch_scene("itemMenu")
            }),
            Option.new("Equip",->(){
                @input.addToStack("Equipment")
                $scene_manager.register("equipMenu",EquipMenu.new())
                $scene_manager.switch_scene("equipMenu")}),
            Option.new("Spells",->(){
                @input.addToStack("spellMenu")
                $scene_manager.register("spellMenu",SpellMenu.new())
                $scene_manager.switch_scene("spellMenu")}),
            
            Option.new("Save",->(){SaveGame.new().writeSave(1)}),
            Option.new("Exit Game",->(){
                @input.removeFromStack(@optionsBox.stackName)
                $scene_manager.input.addToStack("optionsBox")
                $scene_manager.switch_scene("title")
            })]
            back = Option.new("Back",->(){@optionsBox = OptionsBox.new("options",0,0,3,8,@options,"")})
        @optionsBox = OptionsBox.new("options",0,0,3,8,@options,"")
        
        if $scene_manager.feature["party"].party.length > 1
            @aiOptions = [
                Option.new("Melee",->(){$scene_manager.allyAI[@currentPartyMember] = "melee"}),
                Option.new("Ranged",->(){$scene_manager.allyAI[@currentPartyMember] = "ranged"}),
                Option.new("Auto",->(){$scene_manager.allyAI[@currentPartyMember] = "auto"}),
                Option.new("Back",->(){@optionsBox = OptionsBox.new("options",0,0,3,8,@options,"")})
            ]
            @allyOptions = $scene_manager.feature["party"].partyActors.each_with_index.map{|member,index| 
                Option.new(member.name,->(){
                    @currentPartyMember = index
                    @optionsBox.change_options(@aiOptions)
                })
            }
            @allyOptions.delete_at(0)
            @allyOptions.push(back)
            @options.push(Option.new("Ally AI",->(){
                @optionsBox = OptionsBox.new("options",0,0,3,8,@allyOptions,"")
            }))
        end
    end

    def update()
        @party = $scene_manager.feature["party"].party
        @party.each {|e| 
            if e.currentHP <= 0 && e.alive == true
                @deathTotal += 1
                e.alive = false
            end
        }
        if @deathTotal >= @deathCap
            $scene_manager.switch_scene("gameover")
        end

        if KB.key_pressed?(InputTrigger::ESCAPE)
            @input.removeFromStack(@optionsBox.stackName)
            @input.addToStack("map")
            $scene_manager.switch_scene("map")
        end
        @optionsBox.update
    end

    def draw()
        @player = $scene_manager.scene["player"]
        @partyActors = $scene_manager.feature["party"].partyActors
        @currentMap =  $scene_manager.scene["map"].currentMap
        @mWidth, @mHeight = @currentMap.width, @currentMap.height

        #Draw Map Backing
        @camera_x = [[(@player.x) - 800 / 2, 0].max, ((@mWidth * 32) + 32) - 800].min
        @camera_y = [[(@player.y) - 600 / 2, 0].max, ((@mHeight * 32) + 32) - 600].min
        Gosu.translate(-@camera_x, -@camera_y) do
            @currentMap.map.draw
            @currentMap.events.each {|e|e.draw()}
            @partyActors.each{|e|
                        if e.battle.currentHP > 0
                            e.draw
                        end
                        }
            @currentMap.map.drawAbove
        end

        #Draw Party Info
        @partyNames = @party.map{|e|Gosu::Image.from_text(e.name, 25)}
        @partyHP = @party.map{|e|Gosu::Image.from_text("HP: "+e.currentHP.to_s+"/"+e.hp.to_s, 18)}
        @partyLVL = @party.map{|e|Gosu::Image.from_text("Level: "+e.playerLevel.to_s, 18)}
        @partyXP = @party.map{|e|Gosu::Image.from_text("XP: "+e.exp.to_s, 18)}
        @partyGold = Gosu::Image.from_text("Gold: "+$scene_manager.feature["party"].gold.to_s, 18)
        
        for a in (0...@party.length)
            @partyNames[a].draw((10.5*32), 20+(95*a), 8,scale_x = 1, scale_y = 1, color = @white)
            @partyLVL[a].draw((10.5*32), 45+(95*a), 8,scale_x = 1, scale_y = 1, color = @white)
            @partyXP[a].draw((10.5*32), 70+(95*a), 8,scale_x = 1, scale_y = 1, color = @white)
            @partyHP[a].draw((10.5*32), 95+(95*a), 8,scale_x = 1, scale_y = 1, color = @white)
        end

        #Draw Windows And Boxes
        create_window(10,0,10,10)
        create_window(0,10,2,1)    
        @optionsBox.draw
        @partyGold.draw(16,10.5*32,8, 1, 1, @white)
        
    end
end
