require_relative "windowBase.rb"
class ItemMenu
    include WindowBase
    def updateMenu()
        if @inventory.items.is_a?(Array)
            if (@inventory.items.length > 0)
                @items = @inventory.items.each_with_index.map{|e,index| 
                    Option.new(e.name,e.function)
                }
                @items.push(Option.new("Back",->(){
                    @usingItem = false
                }))
            else
                @items = [Option.new("No Items",->(){}),
                        Option.new("Back",->(){
                    @usingItem = false})]
            end
            
        end
    end
    def initialize
        @input = $scene_manager.input
        @inventory = $scene_manager.feature["party"].inventory
        @inventory.register_update_function(->(){
            updateMenu()
        })
        @party = $scene_manager.feature["party"]
        @usingItem = false
        @startOptions = @party.party.each_with_index.map{|member,index| 
            Option.new(member.name,->(){
                @currentPartyMember = index
                @usingItem = true
            })
        }
        @startOptions.push(Option.new("Back",->(){
            @input.addToStack("options")
            $scene_manager.switch_scene("menu")
        }))
        @characterBox = OptionsBox.new("characterBox",0,0,5,11,@startOptions,"")
        updateMenu
        @x,@y,@width,@height = 7,0,17,11
        @choice =  @items.map{|e|e.function}
        @choiceNames = @items.map{|e|e.text_image}
        @choiceAmount = @items.length
        @currentOp = 0
        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000)
        @orange = Gosu::Color.argb(0xff_fc5203)
        @brightGreen = Gosu::Color.argb(0xff_2ca81e)
        @notCurrentColor = @white
        @currentColor = @brightGreen
        @colors = Array.new(40,@notCurrentColor)
        @colors[0] = @currentColor

    end
    
    def doInput(key)
        stackLength = ($scene_manager.input.inputStack.length-1)
        
            @itemChoice =  @inventory.items.map{|e|e.function}
            case key
            when "up"
                if @currentOp != 0
                    @colors[@currentOp] = @notCurrentColor
                    @currentOp -= 1
                    @colors[@currentOp] = @currentColor
                elsif @currentOp == 0
                    @colors[@currentOp] = @notCurrentColor
                    @currentOp = @choiceAmount - 1
                    @colors[@currentOp] = @currentColor
                end
            when "down"
                if @choiceAmount != (@currentOp+1)
                    @colors[@currentOp] = @notCurrentColor
                    @currentOp += 1
                    @colors[@currentOp] = @currentColor
                elsif @choiceAmount == (@currentOp+1)
                    @colors[@currentOp] = @notCurrentColor
                    @currentOp = 0
                    @colors[@currentOp] = @currentColor
                end
            when "select"
                if @currentOp == (@items.length-1)
                    @items[@currentOp].function.call()
                    @colors[@currentOp] = @notCurrentColor
                    @currentOp = 0
                    @colors[@currentOp] = @currentColor
                elsif @itemChoice[@currentOp] != nil
                    @items[@currentOp].function.call(@party.party[@currentPartyMember])
                    @colors[@currentOp] = @notCurrentColor
                    @currentOp = 0
                    @colors[@currentOp] = @currentColor

                    @selectCool = true
                end
            end  
    end
    def update
        updateMenu
        @choice =  @items.map{|e|e.function}
        @choiceNames = @items.map{|e|e.text_image}
        @choiceAmount = @choiceNames.length
        if @usingItem == true
            if @input.keyPressed(InputTrigger::UP) then #down
                doInput("up") 
            elsif @input.keyPressed(InputTrigger::DOWN) then #up
                doInput("down")
            elsif @input.keyPressed(InputTrigger::SELECT) then #select
                doInput("select")
            end
        elsif @usingItem == false
            @characterBox.update
        end
    end
    
    def draw
        create_window(@x,@y,@width,@height)
        create_window(0,13,@width+12,6)
        @characterBox.draw
        @choiceY = (@y*32) + 15
        if @usingItem == true
            for a in (0...@choiceAmount)
                if @choiceY+(20*a) > (@height*32)
                    @choiceNames[a].draw((@x*32)+(@width*32/2), @choiceY+(20*(a-17)), 8,scale_x = 1, scale_y = 1, color = @colors[a])
                elsif @choiceY+(20*a) < (@height*32)
                    @choiceNames[a].draw((@x*32)+10, @choiceY+(20*a), 8,scale_x = 1, scale_y = 1, color = @colors[a])
                end
            end
        elsif @usingItem == false
            for a in (0...@choiceAmount)
                if @choiceY+(20*a) > (@height*32)#
                    @choiceNames[a].draw((@x*32)+(@width*32/2), @choiceY+(20*(a-17)), 8,scale_x = 1, scale_y = 1, color = @notCurrentColor)
                elsif @choiceY+(20*a) < (@height*32)
                    @choiceNames[a].draw((@x*32)+10, @choiceY+(20*a), 8,scale_x = 1, scale_y = 1, color = @notCurrentColor)
                end
            end
        end
    end
end