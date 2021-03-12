require_relative "../files/animate.rb"
require_relative "../files/input_trigger.rb"
require_relative "move_collision.rb"
class Player
    attr_accessor :x, :y, :realX, :realY, :dir, :showPlayer, :collidable, :moving
    attr_reader :sprite
    include MoveCollision
    include Animate
    def initialize()
        @sprite = Gosu::Image.load_tiles("data/images/greenCoat.bmp", 32, 48)
        @showPlayer = true
        @dir = 4
        @x = 10 
        @y = 10 
        @z = 5
        @animate = false
        @canMove = false
        @moving = false
        @time = 100
        @frame = 4
        @collidable = 1
        
        @animateNum = 0
    end

    def move(input,collisionArray,mWidth,mHeight)
        @input,@mWidth,@mHeight = input,mWidth,mHeight
        
        def input_move(key,collisionArray)
            if (Gosu.milliseconds / 34 % 3 == 0)
                @moving, @canMove = true, true
                update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
                    case key
                    when InputTrigger::UP
                        move_event(collisionArray,"up",1,40,30)
                    when InputTrigger::DOWN
                        move_event(collisionArray,"down",1,40,30)
                    when InputTrigger::LEFT
                        move_event(collisionArray,"left",1,40,30)
                    when InputTrigger::RIGHT
                        move_event(collisionArray,"right",1,40,30)
                    end
                    update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
                #if !willCollide(collisionArray,@x,@y,key,40,30)
                #    @canMove = true
                #    @animate = true
                #    @moving = true
                #   else
                #   @canMove = false
                #   @animate = false
                #  @moving = false
                #end
            end
        end
        
        if @input.keyPressed(InputTrigger::UP)
            input_move(InputTrigger::UP,collisionArray)
        elsif  @input.keyPressed(InputTrigger::DOWN)
            input_move(InputTrigger::DOWN,collisionArray)
        elsif @input.keyPressed(InputTrigger::LEFT)
            input_move(InputTrigger::LEFT,collisionArray)
        elsif @input.keyPressed(InputTrigger::RIGHT)
            input_move(InputTrigger::RIGHT,collisionArray)
        elsif $window.button_down(InputTrigger::ESCAPE)
            @input.addToStack("options")
            $scene_manager.switch_scene("menu")
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
        if @showPlayer == true
           draw_character(@sprite,@dir,@x,@y,@z,@animate,@canMove,@time,@frame,@moving)
        end
    end
end