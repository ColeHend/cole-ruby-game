require_relative "input_trigger.rb"
require_relative "option.rb"
require_relative "optionsBox.rb"
require_relative "windowBase.rb"
require_relative "save_game.rb"
class Menu
    include WindowBase

    def updateMenu()
        if @inventory.items.is_a?(Array)
            if (@inventory.items.length > 0)
                @items = @inventory.items.each_with_index.map{|e,index| 
                    Option.new(e.name,->(){})
                }
            else
                @items = [Option.new("No Items",->(){})]
            end
        end
    end

    def initialize()
        @input = $scene_manager.input
        
        @player = $scene_manager.scene["player"]
        @party = $scene_manager.feature["party"]
        @deathCap = @party.maxPartySize
        @deathTotal = @party.deathTotal
        @party = $scene_manager.feature["party"].party
        @showItems = false
        @selectCool = false
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

        @inventory = $scene_manager.feature["party"].inventory
        @inventory.register_update_function(->(){
            updateMenu()
        })
        updateMenu()

        @itemNames = @items.map{|e|e.text_image}
        @itemChoice =  @items.map{|e|e.function}
        @itemAmount = @items.length

        
        #Options and Boxes
        @options = 
            [Option.new("Equip",->(){
                @input.addToStack("Equipment")
                $scene_manager.register("equipMenu",EquipMenu.new())
                $scene_manager.switch_scene("equipMenu")}),
            Option.new("Items",->(){
                @input.addToStack("itemsBox")
                @showItems = true }),
            Option.new("Save",->(){SaveGame.new().writeSave(1)}),
            Option.new("Exit Game",->(){
                @input.removeFromStack(@optionsBox.stackName)
                $scene_manager.input.addToStack("optionsBox")
                $scene_manager.switch_scene("title")
            })]
        @optionsBox = OptionsBox.new("options",0,0,3,8,@options,"")
        @itemsBox = OptionsBox.new("itemsBox",5,0,3,8,@items,"")
        #@optionsBox.exitable = false
        
    end
    def selectCooldown()
        if @selectCool == true
            if ((Gosu::milliseconds - @cooldownTime)) >= 400
                #@cooldownTime = Gosu::milliseconds
                @selectCool = false
            end
        end
    end
    def update()
        @cooldownTime
        selectCooldown()
        @party.each {|e| 
            if e.currentHP <= 0 && e.alive == true
                @deathTotal += 1
                e.alive = false
            end
        }
        if @deathTotal >= @deathCap
            $scene_manager.switch_scene("gameover")
        end

        
        
        if @showItems == true
            
            @inventory = $scene_manager.feature["party"].inventory
            @itemsBox.update
            stackLength = ($scene_manager.input.inputStack.length-1)
            if $scene_manager.input.inputStack[stackLength] == "itemsBox"
                @itemNames = @items.map{|e|e.text_image}
                @itemChoice =  @inventory.items.map{|e|e.function}
                @itemAmount = @items.length

                updateMenu()

                if @input.keyPressed(InputTrigger::UP) then # Up Arrow
                    if @currentItemOp != 0
                        @colors[@currentItemOp] = @notCurrentColor
                        @currentItemOp -= 1
                        @colors[@currentItemOp] = @currentColor
                    end 
                elsif @input.keyPressed(InputTrigger::DOWN) then #Down Arrow
                    if @itemAmount != (@currentItemOp+1)
                        @colors[@currentItemOp] = @notCurrentColor
                        @currentItemOp += 1
                        @colors[@currentItemOp] = @currentColor
                    end
                elsif @input.keyPressed(InputTrigger::SELECT) then #Select Key
                    if @selectCool == false
                        if @itemChoice[@currentItemOp] != nil
                            puts("itemcalled")
                            @itemChoice[@currentItemOp].call(@party[0])
                            @selectCool = true
                        end
                        
                    end
                    @colors = Array.new(25,@notCurrentColor)
                    @colors[@currentItemOp] = @currentColor
                end         
            end
            
        end
        
        if KB.key_pressed?(InputTrigger::ESCAPE)
            if @showItems == true
                @input.removeFromStack(@itemsBox.stackName)
                @showItems = false
            else
                @input.removeFromStack(@optionsBox.stackName)
                @input.addToStack("map")
                $scene_manager.switch_scene("map")
            end
        end
        @optionsBox.update
    end

    def draw()
        @player = $scene_manager.scene["player"]
        @currentMap =  $scene_manager.scene["map"].currentMap
        @mWidth, @mHeight = @currentMap.width, @currentMap.height

        @itemNames = @items.map{|e|e.text_image}
        @itemChoice =  @items.map{|e|e.function}
        @itemAmount = @items.length

        #Draw Map Backing
        @camera_x = [[(@player.x) - 800 / 2, 0].max, ((@mWidth * 32) + 32) - 800].min
        @camera_y = [[(@player.y) - 600 / 2, 0].max, ((@mHeight * 32) + 32) - 600].min
        Gosu.translate(-@camera_x, -@camera_y) do
            @currentMap.map.draw
            @currentMap.events.each {|e|e.draw()}
            @player.draw
            @currentMap.map.drawAbove
        end

        #Draw Party Info
        @partyNames = @party.map{|e|Gosu::Image.from_text(e.name, 25)}
        @partyHP = @party.map{|e|Gosu::Image.from_text("HP: "+e.currentHP.to_s+"/"+e.hp.to_s, 18)}
        @partyLVL = @party.map{|e|Gosu::Image.from_text("Level: "+e.playerLevel.to_s, 18)}
        @partyXP = @party.map{|e|Gosu::Image.from_text("XP: "+e.exp.to_s, 18)}
        
        for a in (0...@party.length)
            @partyNames[a].draw((10*32), 20+(90*a), 8,scale_x = 1, scale_y = 1, color = @white)
            @partyLVL[a].draw((10*32), 45+(90*a), 8,scale_x = 1, scale_y = 1, color = @white)
            @partyXP[a].draw((10*32), 70+(90*a), 8,scale_x = 1, scale_y = 1, color = @white)
            @partyHP[a].draw((10*32), 95+(90*a), 8,scale_x = 1, scale_y = 1, color = @white)
        end

        #Draw Windows And Boxes
        create_window(10,0,10,10)    
        @optionsBox.draw

        if @showItems == true
            #@itemsBox.draw
            create_window(5,0,3,8)
            @itemY = (0*32) + 15
            for a in (0...@itemAmount)
                @itemNames[a].draw((5*32)+10, @itemY+(20*a), 8,scale_x = 1, scale_y = 1, color = @colors[a])
            end
        end
        
    end
end
