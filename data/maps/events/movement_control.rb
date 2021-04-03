require_relative "../../files/animate.rb"
require_relative "move_collision.rb"
require_relative "../scene_map.rb"
require_relative "../map.rb"
require_relative "../map01.rb"
require_relative "../map02.rb"
#require_relative "../player.rb"
#Dir[File.join(__dir__,'..', '*.rb')].each { |file| require_relative file }
module Control_movement
    include Animate
    class Vector2
        attr_accessor :x, :y
        def initialize(x, y)
            @x = x
            @y = y
        end
    end

    def Move(vector,objectToMove,direction,speed=1,timing = 6)
        vector.x = 0
        vector.y = 0
        collisionDetect = MoveCollision.new
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

    def Follow(vectorToMove, objectToMove,range=6*32,objectToFollow=$scene_manager.scene["player"])
        #puts(objectToFollow.x)
        #puts("^follow |  v Move")
        #puts(objectToMove.x)
        #@w = objectToMove.w
        #@h = objectToMove.h
        lockedOn = false
        collisionDetect = MoveCollision.new
        if (objectToFollow.x - objectToMove.x ).abs > (objectToFollow.y - objectToMove.y).abs && (objectToFollow.x - objectToMove.x ).abs <= range #Range
                if objectToFollow.x < objectToMove.x  # && @facing == "left" #player to left
                    if collisionDetect.check_surrounding("left", objectToMove)  == true
                        Move(vectorToMove,objectToMove,"left",1)
                    elsif collisionDetect.check_surrounding("left", objectToMove)  == true
                        if objectToFollow.y > objectToMove.y # player below
                            if collisionDetect.check_surrounding("down", objectToMove)  == true
                                puts("called")
                                Move(vectorToMove,objectToMove,"down",1)
                            elsif collisionDetect.check_surrounding("up", objectToMove)  == true
                                puts("called")
                                Move(vectorToMove,objectToMove,"up",1)
                            end
                        elsif objectToFollow.y < objectToMove.y #player above
                            if collisionDetect.check_surrounding("up", objectToMove)  == true
                                puts("called")
                            Move(vectorToMove,objectToMove,"up",1)
                            elsif collisionDetect.check_surrounding("down", objectToMove)  == true
                                puts("called")
                            Move(vectorToMove,objectToMove,"down",1)
                            end
                        end
                    end
                elsif objectToFollow.x>objectToMove.x  # && @facing == "right" #player to right
                    if collisionDetect.check_surrounding("right", objectToMove)  == true
                        Move(vectorToMove,objectToMove,"right",1)
                    elsif collisionDetect.check_surrounding("right", objectToMove)  == true
                        if objectToFollow.y > objectToMove.y # player below
                            if collisionDetect.check_surrounding("down", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"down",1)
                            elsif collisionDetect.check_surrounding("up", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"up",1)
                            end
                        elsif objectToFollow.y < objectToMove.y #player above
                            if collisionDetect.check_surrounding("up", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"up",1)
                            elsif collisionDetect.check_surrounding("down", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"down",1)
                            end
                        end
                    end
                end
        elsif (objectToFollow.x - objectToMove.x ).abs < (objectToFollow.y - objectToMove.y).abs && (objectToFollow.y - objectToMove.y).abs <= range  #Range
                if objectToFollow.y > objectToMove.y # && @facing == "down" #player to below
                    if collisionDetect.check_surrounding("down", objectToMove)  == true
                        Move(vectorToMove,objectToMove,"down",1)
                    elsif collisionDetect.check_surrounding("down", objectToMove)  == true
                        if objectToFollow.x > objectToMove.x  # player right
                            if collisionDetect.check_surrounding("right", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"right",1)
                            elsif collisionDetect.check_surrounding("left", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"left",1)
                            end
                        else #player left
                            if collisionDetect.check_surrounding("left", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"left",1)
                            elsif collisionDetect.check_surrounding("right", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"right",1)
                            end
                        end
                    end
                elsif objectToFollow.y < objectToMove.y # && @facing == "up" #player to above
                    if collisionDetect.check_surrounding("up", objectToMove)  == true
                        Move(vectorToMove,objectToMove,"up",1)
                    elsif collisionDetect.check_surrounding("up", objectToMove)  == false
                        if objectToFollow.x > objectToMove.x  # player right
                            if collisionDetect.check_surrounding("right", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"right",1)
                            elsif collisionDetect.check_surrounding("left", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"left",1)
                            end
                        else #player left
                            if collisionDetect.check_surrounding("left", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"left",1)
                            elsif collisionDetect.check_surrounding("right", objectToMove)  == true
                            Move(vectorToMove,objectToMove,"right",1)
                            end
                        end
                    end
                end
        elsif (objectToFollow.y - objectToMove.y).abs <= (range) && (objectToFollow.x - objectToMove.x ).abs <= (range)
               # @animate = false
    
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
end
