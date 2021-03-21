require_relative "input_trigger.rb"
require_relative "option.rb"
require_relative "optionsBox.rb"
require_relative "windowBase.rb"
class Menu
    include WindowBase

    def updateMenu()
        if (@inventory.items.length > 0)
            @items = @inventory.items.each_with_index.map{|e,index| 
                Option.new(e.name,->(){
                    $scene_manager.feature["party"].use_item(e,@party[0])
                })
            }
        else
            @items = [Option.new("No Items",->(){})]
        end
    end

    def initialize()
        @input = $scene_manager.input
        
        @party = $scene_manager.feature["party"].party
        @showItems = false
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
        #@items = $scene_manager.feature["party"].items
        @inventory.register_update_function(->(){
            updateMenu()
        })
        updateMenu()

        @itemNames = @items.map{|e|e.text_image}
        @itemChoice =  @items.map{|e|e.function}
        @itemAmount = @items.length

        
        #Options and Boxes
        @options = [Option.new("Party",->(){}),
            Option.new("Items",->(){@input.addToStack("itemsBox")
                @showItems = true }),
                
            Option.new("Save",->(){}),
            Option.new("Exit Game",->(){})]
        @optionsBox = OptionsBox.new("options",0,0,3,8,@options,"")
        @itemsBox = OptionsBox.new("itemsBox",5,0,3,8,@items,"")
        
    end

    def update()
        @optionsBox.update
        
        if @showItems == true
            @inventory = $scene_manager.feature["party"].inventory
            @itemsBox.update
            stackLength = ($scene_manager.input.inputStack.length-1)
        if $scene_manager.input.inputStack[stackLength] == "itemsBox"
            @itemNames = @items.map{|e|e.text_image}
                @itemChoice =  @items.map{|e|e.function}
                @itemAmount = @items.length
                if @items.size >= 1
                    # @items = @inventory.each_with_index.map{|e,index| 
                    # Option.new(e.name,->(){
                    # $scene_manager.feature["party"].use_item(index,@party[0])
                    # })}
                else
                        @items = [Option.new("No Items",->(){})]
                end
            if @input.keyPressed(InputTrigger::UP) then #down
                if @currentItemOp != 0
                    @colors[@currentItemOp] = @notCurrentColor
                    @currentItemOp -= 1
                    @colors[@currentItemOp] = @currentColor
                end 
            elsif @input.keyPressed(InputTrigger::DOWN) then #up
                if @itemAmount != (@currentItemOp+1)
                    @colors[@currentItemOp] = @notCurrentColor
                    @currentItemOp += 1
                    @colors[@currentItemOp] = @currentColor
                end
            elsif @input.keyPressed(InputTrigger::SELECT) then #select
                @itemChoice[@currentItemOp].call()
                
                #@currentItemOp = 0
                @colors = Array.new(25,@notCurrentColor)
                @colors[@currentItemOp] = @currentColor

            end         
        end
            
        end
        
        if KB.key_pressed?(InputTrigger::ESCAPE)
            if @showItems == true
                @input.removeFromStack(@itemsBox.stackName)
                @showItems = false
                #@itemsBox.hidden(true)
                
            else
                @input.removeFromStack(@optionsBox.stackName)
                @input.addToStack("map")
                $scene_manager.switch_scene("map")
            end
        
        end
    end

    def draw()
        @player = $scene_manager.scene["player"]
        @currentMap =  $scene_manager.scene["map"].currentMap
        @mWidth, @mHeight = @currentMap.width, @currentMap.height

        # if @items.size >= 1
        #     @items = @inventory.each_with_index.map{|e,index| 
        #         Option.new(e.name,->(){
        #         $scene_manager.feature["party"].use_item(index,@party[0])
        #     })}
        # else
        #         @items = [Option.new("No Items",->(){})]
        # end
        @itemNames = @items.map{|e|e.text_image}
        @itemChoice =  @items.map{|e|e.function}
        @itemAmount = @items.length

        #Draw Map Backing
        @currentMap.map.draw
        @currentMap.events.each {|e|e.draw()}
        @player.draw

        #Draw Party Info
        @partyNames = @party.map{|e|Gosu::Image.from_text(e.name, 25)}
        @partyHP = @party.map{|e|Gosu::Image.from_text("HP: "+e.currentHP.to_s+"/"+e.hp.to_s, 18)}
        @partyLVL = @party.map{|e|Gosu::Image.from_text("Level: "+e.playerLevel.to_s, 18)}
        @partyXP = @party.map{|e|Gosu::Image.from_text("XP: "+e.exp.to_s, 18)}
        
        for a in (0...@party.length)
            @partyNames[a].draw((10*32)+(74*a), 20, 8,scale_x = 1, scale_y = 1, color = @white)
            @partyLVL[a].draw((10*32)+(74*a), 45, 8,scale_x = 1, scale_y = 1, color = @white)
            @partyXP[a].draw((10*32)+(74*a), 70, 8,scale_x = 1, scale_y = 1, color = @white)
            @partyHP[a].draw((10*32)+(74*a), 95, 8,scale_x = 1, scale_y = 1, color = @white)
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
