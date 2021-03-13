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
        @x = @player.x 
        @y = @player.y 
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
        @forces = Vector.new(0,-1)
        @moving, @canMove = true, true
        update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
        if @input.keyDown(InputTrigger::UP)
            #input_move(InputTrigger::UP,collisionArray)
            #@player.y -= 32
            move_event(collisionArray,"up",5,40,30,@player,@forces)
        elsif @input.keyDown(InputTrigger::DOWN)
            #input_move(InputTrigger::DOWN,collisionArray)
            move_event(collisionArray,"down",5,40,30,@player,@forces)
            #@player.y += 32
        elsif @input.keyDown(InputTrigger::LEFT)
            #input_move(InputTrigger::LEFT,collisionArray)
            move_event(collisionArray,"left",5,40,30,@player,@forces)
            #@player.x -= 32
        elsif @input.keyDown(InputTrigger::RIGHT)
            #input_move(InputTrigger::RIGHT,collisionArray)
            #@player.x += 32
            move_event(collisionArray,"right",5,40,30,@player,@forces)
        elsif @input.keyDown(InputTrigger::ESCAPE)
            @input.addToStack("options")
            $scene_manager.switch_scene("menu")
        else
            @moving = false
            @canMove = false
            @animate = false
            
            update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
        end
        
        #@player.move(@forces,collisionArray,[])
        @theMap.set_camera(0,0)
    end


    def update
        
        
    end
    
    def draw
        @currentMap =  $scene_manager.scene["map"].currentMap.map.theMap
        
        if @showPlayer == true
            
            @player.draw(@currentMap)
        end
    end
end