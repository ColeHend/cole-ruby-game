require_relative "../files/animate.rb"
require_relative "../files/play_animation.rb"
require_relative "../files/input_trigger.rb"
require_relative "./events/movement_control.rb"
require_relative "events/hpbar.rb"
#Dir[File.join(__dir__,'events', '*.rb')].each { |file| require_relative file }
Dir[File.join(__dir__, '*.rb')].each { |file| require file }
include Control_movement
include Animate
class Player
    attr_accessor :x, :y, :dir, :showPlayer, :collidable, :moving, :player, :facing
    attr_reader :sprite
    
    def initialize()
        #@sprite = Gosu::Image.load_tiles("data/img/greenCoat.bmp", 32, 48)
        @player = $scene_manager.register_object("player",:player,3*32,3*32,32,48,4,4)
        @showPlayer = true
        @skillAnimation = PlayAnimation.new
        @dir = 4
        @x = (@player.x )
        @y = (@player.y )
        @z = 5
        @facing = "down"
        @party = $scene_manager.feature["party"]
        @hpbar = HPbar.new(@player.x,@player.y,@party.party[0].hp,@party.party[0].currentHP)
        @animate = false
        @canMove = false
        @moving = false
        @collidable = 1
        
        @animateNum = 0
    end
    def player_attack
        @attacking = true
        case @facing
        when "left"
            @skillAnimation.play_animation("slash",@player.x-5*32,@player.y-32)
        when "right"
            @skillAnimation.play_animation("slash",@player.x-3*32,@player.y-32)
        when "up"
            @skillAnimation.play_animation("slash",@player.x-4*32,@player.y-2*32)
        when "down"
            @skillAnimation.play_animation("slash",@player.x-4*32,@player.y)
        end
    end
    def move(input,theMap)
        @input,@theMap = input,theMap
        @moving, @canMove = true, true
        update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
        moveX = 0
        moveY = 0
        
        vector = Vector2.new(moveX, moveY)
        if Gosu.button_down?(InputTrigger::RUN)
            speed = 1.25
            timing = 5
        elsif Gosu.button_down?(InputTrigger::SNEAK)
            speed = 0.5
            timing = 10
        else
            speed = 0.75
            timing = 7
        end
        if @input.keyDown(InputTrigger::UP)
            Move(vector,@player,"up",speed,timing)
            @facing = "up"
        elsif @input.keyDown(InputTrigger::DOWN)
            Move(vector,@player,"down",speed,timing)
            @facing = "down"
        elsif @input.keyDown(InputTrigger::LEFT)
            Move(vector,@player,"left",speed,timing)
            @facing = "left"
        elsif @input.keyDown(InputTrigger::RIGHT)
            Move(vector,@player,"right",speed,timing)
            @facing = "right"
        end
        if @input.keyPressed(InputTrigger::ATTACK)
            player_attack 
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
        @skillAnimation.update
        
    end
    
    def draw
        @currentMap =  $scene_manager.scene["map"].currentMap.map.theMap
        @player = $scene_manager.object["player"]
        if @showPlayer == true
            @skillAnimation.draw
            @player.draw()
            @hpbar.draw
            
        end
    end
end
