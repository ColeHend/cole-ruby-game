require_relative "windowBase.rb"
require_relative "input_trigger.rb"
class DialogBox 
    attr_reader :stackName
    include WindowBase
    def initialize(x=0,y=10,width=20,height=5,message = "",exitLambda = ->(){})
        @x, @y, @width, @height = x, y, width, height
        @stackName = "dialogBox"
        @input = $scene_manager.input
        @input.addToStack(@stackName)
        @exitLambda = exitLambda
        @evtMessage = Gosu::Image.from_text(message, 15)

        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000) 
        @orange = Gosu::Color.argb(0xff_fc5203)
        @brightGreen = Gosu::Color.argb(0xff_2ca81e)
        @textColor = @white
        @ran = false
    end

    def update()
        if @input.keyPressed(InputTrigger::SELECT)
            @exitLambda.call()
            @input.removeFromStack(@stackName)
            @input.addToStack("map")
            $scene_manager.switch_scene("map")
        end  
    end

    def draw
        @player = $scene_manager.scene["player"]
        @currentMap =  $scene_manager.scene["map"].currentMap
        @mWidth, @mHeight = @currentMap.width, @currentMap.height
        #Draw Map Backing
        @camera_x = [[(@player.x) - 800 / 2, 0].max, ((@mWidth * 32) + 32) - 800].min
        @camera_y = [[(@player.y) - 600 / 2, 0].max, ((@mHeight * 32) + 32) - 600].min
        Gosu.translate(-@camera_x, -@camera_y) do
            @currentMap.map.draw
            @currentMap.events.each {|e|e.draw()}
            @player.draw
            @currentMap.map.drawAbove
        end

        create_window(@x,@y,@width,@height) 
        @evtMessage.draw((@x*32)+15,(@y*32)+15,20,scale_x=1,scale_y=1,color=@textColor)

        
        
    end
end
