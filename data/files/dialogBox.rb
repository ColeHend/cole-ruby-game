require_relative "windowBase.rb"
require_relative "input_trigger.rb"
class DialogBox 
    attr_reader :stackName
    include WindowBase
    def initialize(x=0,y=10,width=20,height=5,stackName,message)
        @x, @y, @width, @height = x, y, width, height
        @stackName = stackName
        @input = $scene_manager.input
        @input.addToStack(@stackName)
        
        @evtMessage = Gosu::Image.from_text(message, 15)

        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000) 
        @orange = Gosu::Color.argb(0xff_fc5203)
        @brightGreen = Gosu::Color.argb(0xff_2ca81e)
        @textColor = @white
        @ran = false
    end

    def draw_box(exitLambda)
        def drawing()
            create_window(@x,@y,@width,@height) 
            @evtMessage.draw((@x*32)+15,(@y*32)+15,8,scale_x=1,scale_y=1,color=@textColor)
        end
        drawing()
        if (Gosu.milliseconds / 30 % 3 == 0)
            if $window.button_down(InputTrigger::SELECT)
                exitLambda.call()
                @input.removeFromStack(@stackName)
            end
        end
    end


end
