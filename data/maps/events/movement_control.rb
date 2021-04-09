require_relative "../../files/animate.rb"
require_relative "../abs/fight_center.rb"
require_relative "move_collision.rb"
require_relative "../scene_map.rb"
require_relative "../map.rb"
require_relative "../map01.rb"
require_relative "../map02.rb"
require_relative "../characters/magic/magic_attack.rb"
#require_relative "../player.rb"
#Dir[File.join(__dir__,'..', '*.rb')].each { |file| require_relative file }
class Vector2
    attr_accessor :x, :y
    def initialize(x, y)
        @x = x
        @y = y
    end
end
class Control_movement
    include Animate
    def initialize(name)
        @skillAnimation = PlayAnimation.new
        @name = name
    end

    def Move(vector,objectToMove,direction,speed=1,timing = 6)
        vector.x = 0
        vector.y = 0
        collisionDetect = MoveCollision.new(@name)
        
        case direction
            when "down"
                vector.y = speed
            when "up"
                vector.y = -speed
            when "right"
                vector.x = speed
            when "left"
                vector.x = -speed
            when "none"
                vector.x = 0
                vector.y = 0
        end

        objectToMove = objectToMove
        newXPos = objectToMove.x + (vector.x * 4)
        newYPos = objectToMove.y + (vector.y * 4)
        if vector.y > 0
            if collisionDetect.check_surrounding("down",objectToMove) == false
                objectToMove.y = newYPos
                draw_character(objectToMove, "down",timing)
            end
        elsif vector.y < 0
            if collisionDetect.check_surrounding("up",objectToMove) == false
                objectToMove.y = newYPos
                draw_character(objectToMove, "up",timing)
            end
        elsif vector.x > 0
            if collisionDetect.check_surrounding("right",objectToMove) == false
                objectToMove.x = newXPos
                draw_character(objectToMove, "right",timing)
            end
        elsif vector.x < 0
            if collisionDetect.check_surrounding("left",objectToMove) == false
                objectToMove.x = newXPos
                draw_character(objectToMove, "left",timing)
            end
        end
        
    end

    def eventAtkChoice(objectToMove,attackerClass,objectToFollow=$scene_manager.scene["player"],detectRange=6*32,actionRange=6*32,atkRange="ranged")
        #fightControl = FightCenter.new.meleeAttack(objectToMove,"left","firebolt")
        @magicAttack = MagicBook.new(attackerClass.battle.int)
        #meleeAttack(attackerObj,attacker,facing,rangeBoost=0)
        #magicAttack(attackerObj,attacker,facing,rangeBoost)
        detectDist = detectRange
        closestDist = actionRange
        fightControl = FightCenter.new(attackerClass.name)
        if objectToFollow.x != objectToMove.x && objectToFollow.y != objectToMove.y
            if (objectToFollow.x - objectToMove.x ).abs <= detectDist && (objectToFollow.y - objectToMove.y ).abs <= detectDist
                if (objectToFollow.x - objectToMove.x ).abs >= closestDist && (objectToFollow.y - objectToMove.y ).abs >= closestDist
                    if MoveCollision.new.check_collision(objectToMove,closestDist,false) == true || MoveCollision.new.check_player_collision(objectToMove,closestDist,false) == true
                        if atkRange == "melee"
                            case attackerClass.facing
                            when "left"
                                @skillAnimation.play_animation("slash",objectToMove.x-4*32,objectToMove.y-2*32,nil)
                                fightControl.meleeAttack(objectToMove,attackerClass.battle,attackerClass.facing,32)
                            when "right"
                                @skillAnimation.play_animation("slash",objectToMove.x-1.8*32,objectToMove.y-2.1*32,:horiz)
                                fightControl.meleeAttack(objectToMove,attackerClass.battle,attackerClass.facing,32)
                            when "up"
                                @skillAnimation.play_animation("slash",objectToMove.x-3*32,objectToMove.y-3*32,nil)
                                fightControl.meleeAttack(objectToMove,attackerClass.battle,attackerClass.facing,32)
                            when "down"
                                @skillAnimation.play_animation("slash",objectToMove.x-3*32,objectToMove.y-2*32,:vert)
                                fightControl.meleeAttack(objectToMove,attackerClass.battle,attackerClass.facing,32)
                            end
                            #@skillAnimation.play_animation("slash",objectToMove.x-4*32,objectToMove.y-2*32,nil)
                            #FightCenter.new.meleeAttack(objectToMove,attackerClass.battle,attackerClass.facing,0)
                        elsif atkRange == "ranged"
                            @magicAttack.ranged_shot(objectToMove,attackerClass.facing,"firebolt")
                        else
                        end
                    end
                end
            end
        end
    end
    
    def Follow(vectorToMove,attackerClass, objectToMove,atkType="ranged",range=6*32,actRange=2*32,objectToFollow=$scene_manager.scene["player"])
        #puts(objectToFollow.x)
        #puts("^follow |  v Move")
        #puts(objectToMove.x)
        #@w = objectToMove.w
        #@h = objectToMove.h
        lockedOn = false
        detectDist = range
        closestDist = 0
        objDetect = MoveCollision.new
        speed = 0.25
        time = 10

        eventAtkChoice(objectToMove,attackerClass,objectToFollow,range,actRange,atkType) #  <- Starts its attack logic

        if (objectToFollow.x - objectToMove.x ).abs <= detectDist && (objectToFollow.y - objectToMove.y ).abs <= detectDist
            if (objectToFollow.x - objectToMove.x ).abs >= closestDist && (objectToFollow.y - objectToMove.y ).abs >= closestDist
                if (objectToFollow.x - objectToMove.x ).abs >= (objectToFollow.y - objectToMove.y).abs && (objectToFollow.x - objectToMove.x ).abs <= range # In Range X Dis Greater
                    if objectToFollow.x <= objectToMove.x
                        if objDetect.check_surrounding("left", objectToMove)  == false
                            attackerClass.facing = "left"
                            Move(vectorToMove,objectToMove,"left",speed,time)
                            
                        elsif objDetect.check_surrounding("left", objectToMove)  == true
                            
                            if objDetect.check_surrounding("down", objectToMove)  == false
                                attackerClass.facing = "down"
                                Move(vectorToMove,objectToMove,"down",speed,time)
                            elsif objDetect.check_surrounding("up", objectToMove)  == false
                                attackerClass.facing = "up"
                                Move(vectorToMove,objectToMove,"up",speed,time)
                            end
                        end
                    elsif objectToFollow.x>objectToMove.x
                        if objDetect.check_surrounding("right", objectToMove)  == false
                            attackerClass.facing = "right"
                            Move(vectorToMove,objectToMove,"right",speed,time)
                        elsif objDetect.check_surrounding("right", objectToMove)  == true
                            if objDetect.check_surrounding("down", objectToMove)  == false
                                attackerClass.facing = "down"
                                Move(vectorToMove,objectToMove,"down",speed,time)
                            elsif objDetect.check_surrounding("up", objectToMove)  == false
                                attackerClass.facing = "up"
                                Move(vectorToMove,objectToMove,"up",speed,time)
                            end
                        end
                    end
                elsif (objectToFollow.x - objectToMove.x ).abs <= (objectToFollow.y - objectToMove.y).abs && (objectToFollow.y - objectToMove.y).abs <= range # In Range Y Dis Greater
                    if objectToFollow.y >= objectToMove.y
                        if objDetect.check_surrounding("down", objectToMove)  == false
                            attackerClass.facing = "down"
                            Move(vectorToMove,objectToMove,"down",speed,time)
                        elsif objDetect.check_surrounding("down", objectToMove)  == true
                            if objDetect.check_surrounding("right", objectToMove)  == false
                                attackerClass.facing = "right"
                                Move(vectorToMove,objectToMove,"right",speed,time)
                            elsif objDetect.check_surrounding("left", objectToMove)  == false
                                attackerClass.facing = "left"
                                Move(vectorToMove,objectToMove,"left",speed,time)
                            end
                        end
                    elsif objectToFollow.y < objectToMove.y
                        if objDetect.check_surrounding("up", objectToMove)  == false
                            attackerClass.facing = "up"
                            Move(vectorToMove,objectToMove,"up",speed,time)
                        elsif objDetect.check_surrounding("up", objectToMove)  == true
                            if objDetect.check_surrounding("right", objectToMove)  == false
                                attackerClass.facing = "right"
                                Move(vectorToMove,objectToMove,"right",speed,time)
                            elsif objDetect.check_surrounding("left", objectToMove)  == false
                                attackerClass.facing = "left"
                                Move(vectorToMove,objectToMove,"left",speed,time)
                            end
                        end
                    end
                elsif (objectToFollow.y - objectToMove.y).abs <= (range) && (objectToFollow.x - objectToMove.x ).abs <= (range) # In Range Else
                    if objectToFollow.y >= objectToMove.y
                        if objDetect.check_surrounding("down", objectToMove)  == false
                            attackerClass.facing = "down"
                            Move(vectorToMove,objectToMove,"down",speed,time)
                        elsif objDetect.check_surrounding("down", objectToMove)  == true
                            if objDetect.check_surrounding("right", objectToMove)  == false
                                attackerClass.facing = "right"
                                Move(vectorToMove,objectToMove,"right",speed,time)
                            elsif objDetect.check_surrounding("left", objectToMove)  == false
                                attackerClass.facing = "left"
                                Move(vectorToMove,objectToMove,"left",speed,time)
                            end
                        end
                    elsif objectToFollow.y < objectToMove.y
                        if objDetect.check_surrounding("up", objectToMove)  == false
                            attackerClass.facing = "up"
                            Move(vectorToMove,objectToMove,"up",speed,time)
                        elsif objDetect.check_surrounding("up", objectToMove)  == true
                            if objDetect.check_surrounding("right", objectToMove)  == false
                                attackerClass.facing = "right"
                                Move(vectorToMove,objectToMove,"right",speed,time)
                            elsif objDetect.check_surrounding("left", objectToMove)  == false
                                attackerClass.facing = "left"
                                Move(vectorToMove,objectToMove,"left",speed,time)
                            end
                        end
                    end
                end
            end
        end

    end
        
    def RandomMove(vectorToMove,objectToMove,randomDir,delayStart=490)
        @randomNum = rand(4)
        @delayStop = Gosu.milliseconds

        if (@delayStop - delayStart < 500)
            case @randomNum
            when 0
                Move(vectorToMove,objectToMove,"none")
            when 1
                Move(vectorToMove,objectToMove,"right",1)
            when 2
                Move(vectorToMove,objectToMove,"up",1)
            when 3
                Move(vectorToMove,objectToMove,"left",1)
            when 4
                Move(vectorToMove,objectToMove,"down",1)
            end
        end
    end   
    
    def triggerEvent(targetObject,activateType="SELECT")
        # targetObject is likely the player
        # returns the event in that direction if present
        collisionDetect = MoveCollision.new
        upEventCheck = collisionDetect.checkDir(targetObject,"up",0,true)
        downEventCheck = collisionDetect.checkDir(targetObject,"down",0,true)
        leftEventCheck = collisionDetect.checkDir(targetObject,"left",0,true)
        rightEventCheck = collisionDetect.checkDir(targetObject,"right",0,true)
        
        #check if input and colliding
        if collisionDetect.checkDir(targetObject,"up") == true
            activateType = upEventCheck
            activateType = activateType.activateType
        elsif collisionDetect.checkDir(targetObject,"down") == true
            activateType = downEventCheck
            activateType = activateType.activateType
        elsif collisionDetect.checkDir(targetObject,"left") == true
            activateType = leftEventCheck
            activateType = activateType.activateType
        elsif collisionDetect.checkDir(targetObject,"right") == true
            activateType = rightEventCheck
            activateType = activateType.activateType
        else
            activateType = "SELECT"
        end
        
        if activateType == "SELECT"
            if KB.key_pressed?(InputTrigger::SELECT)
                if collisionDetect.checkDir(targetObject,"up") == true
                    upEventCheck.activate_event
                elsif collisionDetect.checkDir(targetObject,"down") == true
                    downEventCheck.activate_event
                elsif collisionDetect.checkDir(targetObject,"left") == true
                    leftEventCheck.activate_event
                elsif collisionDetect.checkDir(targetObject,"right") == true
                    rightEventCheck.activate_event
                end
            end
        elsif activateType == "TOUCH"
            if collisionDetect.checkDir(targetObject,"up") == true
                upEventCheck.activate_event
            elsif collisionDetect.checkDir(targetObject,"down") == true
                downEventCheck.activate_event
            elsif collisionDetect.checkDir(targetObject,"left") == true
                leftEventCheck.activate_event
            elsif collisionDetect.checkDir(targetObject,"right") == true
                rightEventCheck.activate_event
            end
        end
    end
    def update
        @skillAnimation.update
        if @magicAttack != nil
            @magicAttack.update
        end
    end
    def draw
        @skillAnimation.draw
        if @magicAttack != nil
            @magicAttack.draw
        end
    end
end
