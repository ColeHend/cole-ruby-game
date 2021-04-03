require_relative "windowBase.rb"
require_relative "input_trigger.rb"
class OptionsBox
    attr_accessor :notCurrentColor, :currentColor, :hidden
    attr_reader :currentOp, :stackName
    include WindowBase
    def initialize(stackName,x=400,y=225,width=70,height=70,choice,done)
        @stackName = stackName
        @input = $scene_manager.input #
        @input.addToStack(stackName)
        @inputStackSpot = @input.inputStack.length
        @hidden = false
        @x, @y, @width, @height = x, y, width, height
        @choices = choice
        @choiceNames = @choices.map{|e|e.text_image}
        @choice =  @choices.map{|e|e.function}
        @choiceAmount = @choiceNames.length 
        @done = done
        @drawChoice,@currentOp = true,0

        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000)
        @orange = Gosu::Color.argb(0xff_fc5203)
        @brightGreen = Gosu::Color.argb(0xff_2ca81e)
        @notCurrentColor = @white
        @currentColor = @brightGreen
        @colors = Array.new(40,@notCurrentColor)
        @colors[0] = @currentColor
        @buttondown = 0
        @player = $scene_manager.scene["player"]
        #$can_move = !@drawDialog
    end

    
    
    def doInput(key)
        stackLength = ($scene_manager.input.inputStack.length-1)
        if $scene_manager.input.inputStack[stackLength] == @stackName
            case key
            when "up"
                if @currentOp != 0
                    @colors[@currentOp] = @notCurrentColor
                    @currentOp -= 1
                    @colors[@currentOp] = @currentColor
                end
            when "down"
                if @choiceAmount != (@currentOp+1)
                    @colors[@currentOp] = @notCurrentColor
                    @currentOp += 1
                    @colors[@currentOp] = @currentColor
                end
            when "select"
                    @choice[@currentOp].call()
                    #@currentOp = 0
                    @colors = Array.new(25,@notCurrentColor)
                    @colors[@currentOp] = @currentColor
                    
                    @done = true
            end          
        end
    end

    def update
        if @input.keyPressed(InputTrigger::UP) then #down
            doInput("up") 
        elsif @input.keyPressed(InputTrigger::DOWN) then #up
            doInput("down")
        elsif @input.keyPressed(InputTrigger::SELECT) then #select
            doInput("select")
        end
        @choiceNames = @choices.map{|e|e.text_image}
        @choice =  @choices.map{|e|e.function}
        @choiceAmount = @choiceNames.length
    end
        
    def hidden(visible)
        @hidden = visible
    end  
      
    def draw
        if !@hidden
            create_window(@x,@y,@width,@height)
            @choiceY = (@y*32) + 15
            for a in (0...@choiceAmount)
                @choiceNames[a].draw((@x*32)+10, @choiceY+(20*a), 8,scale_x = 1, scale_y = 1, color = @colors[a])
            end
        end
    end
      
end
