require_relative "../files/animate.rb"
require_relative "../files/input_trigger.rb"
require_relative "move_collision.rb"
class Player
    attr_accessor :x, :y, :realX, :realY, :dir, :showPlayer, :collidable, :moving, :player
    attr_reader :sprite
    include MoveCollision
    include Animate
    def initialize()
        #@sprite = Gosu::Image.load_tiles("data/img/greenCoat.bmp", 32, 48)
        @player = $scene_manager.register_object("player",:player,3*32,3*32,32,48,4,4)
        @showPlayer = true
        @dir = 4
        @x = (@player.x / 32)
        @y = (@player.y / 32)
        @z = 5
        @animate = false
        @canMove = false
        @moving = false
        @time = 100
        @frame = 4
        @collidable = 1
        
        @animateNum = 0
    end

    def move(input,collisionArray,theMap)
        @input,@theMap = input,theMap
        @moving, @canMove = true, true
        update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
        if @input.keyDown(InputTrigger::UP)
            move_event(collisionArray,"up",5,40,30,@player,@forces)
        elsif @input.keyDown(InputTrigger::DOWN)
            move_event(collisionArray,"down",5,40,30,@player,@forces)
        elsif @input.keyDown(InputTrigger::LEFT)
            move_event(collisionArray,"left",5,40,30,@player,@forces)
        elsif @input.keyDown(InputTrigger::RIGHT)
            move_event(collisionArray,"right",5,40,30,@player,@forces)
        elsif @input.keyDown(InputTrigger::ESCAPE)
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
        
        
    end
    
    def draw
        @currentMap =  $scene_manager.scene["map"].currentMap.map.theMap
        
        if @showPlayer == true
            
            @player.draw()
        end
    end
end