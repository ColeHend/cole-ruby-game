require_relative "../files/animate.rb"
require_relative "../files/input_trigger.rb"
require_relative "move_collision.rb"
require_relative "events/hpbar.rb"
class Player
    attr_accessor :x, :y, :dir, :showPlayer, :collidable, :moving, :player
    attr_reader :sprite
    include MoveCollision
    include Animate
    def initialize()
        #@sprite = Gosu::Image.load_tiles("data/img/greenCoat.bmp", 32, 48)
        @player = $scene_manager.register_object("player",:player,5*32,3*32,32,48,4,4)
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
        if @input.keyDown(InputTrigger::UP)
            move_event("up",1,@player,"up")
        elsif @input.keyDown(InputTrigger::DOWN)
            move_event("down",1,@player,"down")
        elsif @input.keyDown(InputTrigger::LEFT)
            move_event("left",1,@player,"left")
        elsif @input.keyDown(InputTrigger::RIGHT)
            move_event("right",1,@player,"right")
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