require_relative "../files/animate.rb"
require_relative "../files/play_animation.rb"
require_relative "../files/input_trigger.rb"
require_relative "./events/movement_control.rb"
require_relative "abs/fight_center.rb"
require_relative "characters/magic/magic_attack.rb"
Dir[File.join(__dir__, '*.rb')].each { |file| require file }
include Animate
class PlayerControl
    attr_accessor :facing, :name
    def initialize() #meleeAttack(attackerObj,attacker,facing,rangeBoost=0)
        @playerObj = $scene_manager.object["player"]
        @playerBattle = $scene_manager.feature["party"].party[0]
        @name = @playerBattle.name
        @skillAnimation = PlayAnimation.new
        @x = (@playerObj.x )
        @y = (@playerObj.y )
        @input = $scene_manager.input
        @facing = "down"
        @fightControl = FightCenter.new
        @moveControl = Control_movement.new(@name)
        @magicAttack = MagicBook.new(@playerBattle.int)
    end
    def player_attack
        if @input.keyPressed(InputTrigger::ATTACK)
            case @facing
            when "left"
                @skillAnimation.play_animation("slash",@playerObj.x-4*32,@playerObj.y-2*32,nil)
                @fightControl.meleeAttack(@playerObj,@playerBattle,@facing,32)
            when "right"
                @skillAnimation.play_animation("slash",@playerObj.x-1.8*32,@playerObj.y-2.1*32,:horiz)
                @fightControl.meleeAttack(@playerObj,@playerBattle,@facing,32)
            when "up"
                @skillAnimation.play_animation("slash",@playerObj.x-3*32,@playerObj.y-3*32,nil)
                @fightControl.meleeAttack(@playerObj,@playerBattle,@facing,32)
            when "down"
                @skillAnimation.play_animation("slash",@playerObj.x-3*32,@playerObj.y-2*32,:vert)
                @fightControl.meleeAttack(@playerObj,@playerBattle,@facing,32)
            end
        elsif @input.keyPressed(InputTrigger::SPELL)
                @magicAttack.ranged_shot(@playerObj,@facing,"firebolt")
        end
    end
    def move_input
        moveX = 0
        moveY = 0
        
        vector = Vector2.new(moveX, moveY)
        if Gosu.button_down?(InputTrigger::RUN)
            speed = 1.25
            animationTime = 5
        elsif Gosu.button_down?(InputTrigger::SNEAK)
            speed = 0.25
            animationTime = 10
        else
            speed = 0.75
            animationTime = 7
        end

        if @input.keyDown(InputTrigger::UP)
            @moveControl.Move(vector,@playerObj,"up",speed,animationTime)
            @facing = "up"
        elsif @input.keyDown(InputTrigger::DOWN)
            @moveControl.Move(vector,@playerObj,"down",speed,animationTime)
            @facing = "down"
        elsif @input.keyDown(InputTrigger::LEFT)
            @moveControl.Move(vector,@playerObj,"left",speed,animationTime)
            @facing = "left"
        elsif @input.keyDown(InputTrigger::RIGHT)
            @moveControl.Move(vector,@playerObj,"right",speed,animationTime)
            @facing = "right"
        end

        @moveControl.triggerEvent(@playerObj)
        if @input.keyDown(InputTrigger::ESCAPE)
            @input.addToStack("options")
            $scene_manager.switch_scene("menu")
        elsif @input.keyReleased(InputTrigger::UP)
            draw_character(@playerObj, "upStop",1)
        elsif @input.keyReleased(InputTrigger::DOWN)
            draw_character(@playerObj, "downStop",1)
        elsif @input.keyReleased(InputTrigger::LEFT)
            draw_character(@playerObj, "leftStop",1)
        elsif @input.keyReleased(InputTrigger::RIGHT)
            draw_character(@playerObj, "rightStop",1)
        else
            
        end

        
            
    end

    def update
        @playerObj = $scene_manager.object["player"]
        $scene_manager.scene["map"].currentMap.events.each {|e| e.update()}#update events collision
        @x = (@playerObj.x)
        @y = (@playerObj.y)
        @skillAnimation.update
        @magicAttack.update
        move_input
        player_attack
    end

    def draw
        @skillAnimation.draw
        @magicAttack.draw
    end


end