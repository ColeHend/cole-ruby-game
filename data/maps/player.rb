require_relative "../files/animate.rb"
require_relative "../files/input_trigger.rb"
require_relative "./events/movement_control.rb"
require_relative "events/hpbar.rb"
#Dir[File.join(__dir__,'events', '*.rb')].each { |file| require_relative file }
Dir[File.join(__dir__, '*.rb')].each { |file| require file }
include Control_movement
include Animate
class Player
    attr_accessor :x, :y, :dir, :showPlayer, :collidable, :moving, :player
    attr_reader :sprite
    
    def initialize()
        #@sprite = Gosu::Image.load_tiles("data/img/greenCoat.bmp", 32, 48)
        @player = $scene_manager.register_object("player",:player,3*32,3*32,32,48,4,4)
        @showPlayer = true
        @dir = 4
        @x = (@player.x )
        @y = (@player.y )
        @z = 5
        @party = $scene_manager.feature["party"]
        @hpbar = HPbar.new(@player.x,@player.y,@party.party[0].hp,@party.party[0].currentHP)
        @animate = false
        @canMove = false
        @moving = false
        @collidable = 1
        
        @animateNum = 0
    end

    def move(input,theMap)
        @input,@theMap = input,theMap
        @moving, @canMove = true, true
        update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
        moveX = 0
        moveY = 0
        vector = Vector2.new(moveX, moveY)
        if @input.keyDown(InputTrigger::UP)
            Move(vector,@player,"up",speed=1)
        elsif @input.keyDown(InputTrigger::DOWN)
            Move(vector,@player,"down",speed=1)
        elsif @input.keyDown(InputTrigger::LEFT)
            Move(vector,@player,"left",speed=1)
        elsif @input.keyDown(InputTrigger::RIGHT)
            Move(vector,@player,"right",speed=1)
        end
        
        triggerEvent(@player)
        if @input.keyDown(InputTrigger::ESCAPE)
            @input.addToStack("options")
            $scene_manager.switch_scene("menu")
        elsif @input.keyReleased(InputTrigger::UP)
            draw_character(@player, "upStop",1)
        elsif @input.keyReleased(InputTrigger::DOWN)
            draw_character(@player, "downStop",1)
        elsif @input.keyReleased(InputTrigger::LEFT)
            draw_character(@player, "leftStop",1)
        elsif @input.keyReleased(InputTrigger::RIGHT)
            draw_character(@player, "rightStop",1)
        else
            @moving = false
            @canMove = false
            @animate = false
            
            update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
        end
        
    end


    def update
        @player = $scene_manager.object["player"]
        @x = (@player.x)
        @y = (@player.y)
        @hpbar.update(@player.x,@player.y,@party.party[0].hp,@party.party[0].currentHP)
        
    end
    
    def draw
        @currentMap =  $scene_manager.scene["map"].currentMap.map.theMap
        
        if @showPlayer == true
            
            @player.draw()
            @hpbar.draw
        end
    end
end
