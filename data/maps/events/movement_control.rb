require_relative "../../files/animate.rb"
require_relative "move_collision.rb"
require_relative "../scene_map.rb"
require_relative "../map.rb"
require_relative "../map01.rb"
require_relative "../map02.rb"
#require_relative "../player.rb"
#Dir[File.join(__dir__,'..', '*.rb')].each { |file| require_relative file }
module Control_movement
    include MoveCollision, Animate
    class Vector2
        attr_accessor :x, :y
        def initialize(x, y)
            @x = x
            @y = y
        end
    end

    def Move(vector,objectToMove,direction,speed=1)
        vector.x = 0
        vector.y = 0

        case direction
            when "down"
                vector.y = 1
            when "up"
                vector.y = -1
            when "right"
                vector.x = 1
            when "left"
                vector.x = -1
            when "none"
                vector.x = 0
                vector.y = 0
        end

        newXPos = objectToMove.x + (vector.x * 4)
        newYPos = objectToMove.y + (vector.y * 4)

        if vector.y > 0
            if check_surrounding("down",objectToMove) != true
                objectToMove.y = newYPos
                draw_character(objectToMove, "down",5)
            end
        elsif vector.y < 0
            if check_surrounding("up",objectToMove) != true
                objectToMove.y = newYPos
                draw_character(objectToMove, "up",5)
            end
        elsif vector.x > 0
            if check_surrounding("right",objectToMove) != true
                objectToMove.x = newXPos
                draw_character(objectToMove, "right",5)
            end
        elsif vector.x < 0
            if check_surrounding("left",objectToMove) != true
                objectToMove.x = newXPos
                draw_character(objectToMove, "left",5)
            end
        end
        
    end

    def Follow(vectorToMove, objectToMove,range=6*32,objectToFollow=$scene_manager.scene["player"])
        objectX = objectToMove.x 
        objectY = objectToMove.y 
        #@w = objectToMove.w
        #@h = objectToMove.h
        playerX = objectToFollow.x
        playerY = objectToFollow.y
        lockedOn = false

        if (playerX - objectX).abs > (playerY - objectY).abs && (playerX - objectX).abs <= range #Range
                if playerX < objectX && @facing == "left" #player to left
                    if check_surrounding("left", objectToMove)  != true
                        Move(vectorToMove,objectToMove,"left")
                    elsif check_surrounding("left", objectToMove)  != true
                        if playerY > objectY # player below
                            if check_surrounding("down", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"down")
                            elsif check_surrounding("up", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"up")
                            end
                        elsif playerY < objectY #player above
                            if check_surrounding("up", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"up")
                            elsif check_surrounding("down", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"down")
                            end
                        end
                    end
                elsif playerX>objectX && @facing == "right" #player to right
                    if check_surrounding("right", objectToMove)  != true
                        Move(vectorToMove,objectToMove,"right")
                    elsif check_surrounding("right", objectToMove)  != true
                        if playerY > objectY # player below
                            if check_surrounding("down", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"down")
                            elsif check_surrounding("up", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"up")
                            end
                        elsif playerY < objectY #player above
                            if check_surrounding("up", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"up")
                            elsif check_surrounding("down", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"down")
                            end
                        end
                    end
                end
        elsif (playerX - objectX).abs < (playerY - objectY).abs && (playerY - objectY).abs <= range  #Range
                if playerY > objectY && @facing == "down" #player to below
                    if check_surrounding("down", objectToMove)  != true
                        Move(vectorToMove,objectToMove,"down")
                    elsif check_surrounding("down", objectToMove)  != true
                        if playerX > objectX # player right
                            if check_surrounding("right", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"right")
                            elsif check_surrounding("left", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"left")
                            end
                        else #player left
                            if check_surrounding("left", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"left")
                            elsif check_surrounding("right", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"right")
                            end
                        end
                    end
                elsif playerY < objectY && @facing == "up" #player to above
                    if check_surrounding("up", objectToMove)  != true
                        Move(vectorToMove,objectToMove,"up")
                    elsif check_surrounding("up", objectToMove)  != true
                        if playerX > objectX # player right
                            if check_surrounding("right", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"right")
                            elsif check_surrounding("left", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"left")
                            end
                        else #player left
                            if check_surrounding("left", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"left")
                            elsif check_surrounding("right", objectToMove)  != true
                            Move(vectorToMove,objectToMove,"right")
                            end
                        end
                    end
                end
        elsif (playerY - objectY).abs <= (@range) && (playerX - objectX).abs <= (@range)
               # @animate = false
    
        end
    end
        
    def RandomMove(vectorToMove,objectToMove,randomDir,delayStart=490)
        @randomNum = rand(4)
        @delayStop = Gosu.milliseconds
        if (@delayStop - delayStart < 500)
            case randomDir
            when 0
                Move(vectorToMove,objectToMove,"none")
            when 1
                Move(vectorToMove,objectToMove,"right")
            when 2
                Move(vectorToMove,objectToMove,"up")
            when 3
                Move(vectorToMove,objectToMove,"left")
            when 4
                Move(vectorToMove,objectToMove,"down")
            end
        end
    end   
    
    def triggerEvent(targetObject,activateType="SELECT")
        # returns the event in that direction if present
        upEventCheck = checkDir(targetObject,"up",0,true)
        downEventCheck = checkDir(targetObject,"down",0,true)
        leftEventCheck = checkDir(targetObject,"left",0,true)
        rightEventCheck = checkDir(targetObject,"right",0,true)
        #check if input and colliding
        if activateType == "SELECT"
            if KB.key_pressed?(InputTrigger::SELECT)
                if checkDir(targetObject,"up") == true
                    upEventCheck.activate_event
                elsif checkDir(targetObject,"down") == true
                    downEventCheck.activate_event
                elsif checkDir(targetObject,"left") == true
                    leftEventCheck.activate_event
                elsif checkDir(targetObject,"right") == true
                    rightEventCheck.activate_event
                end
            end
        elsif activateType == "TOUCH"
            if checkDir(targetObject,"up") == true
                upEventCheck.activate_event
            elsif checkDir(targetObject,"down") == true
                downEventCheck.activate_event
            elsif checkDir(targetObject,"left") == true
                leftEventCheck.activate_event
            elsif checkDir(targetObject,"right") == true
                rightEventCheck.activate_event
            end
        end
    end
end
