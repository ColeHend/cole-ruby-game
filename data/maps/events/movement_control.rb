require_relative "../../files/animate.rb"
require_relative "move_collision.rb"
require_relative "../scene_map.rb"
require_relative "../map.rb"
require_relative "../map01.rb"
require_relative "../map02.rb"

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
    
    def Follow(vectorToMove,attackerClass, objectToMove,atkType="ranged",range=6*32,objectToFollow)
        lockedOn = false
        detectDist = range
        closestDist = 0
        objDetect = MoveCollision.new
        speed = 0.25
        time = 10
    
        if objectToFollow != nil
            if (objectToFollow.x - objectToMove.x ).abs <= detectDist && (objectToFollow.y - objectToMove.y ).abs <= detectDist
                if (objectToFollow.x - objectToMove.x ).abs >= closestDist && ((objectToFollow.y-16) - objectToMove.y ).abs >= closestDist
                    if (objectToFollow.x - objectToMove.x ).abs >= ((objectToFollow.y-16) - objectToMove.y).abs && ((objectToFollow.x-16) - objectToMove.x ).abs <= range # In Range X Dis Greater
                        if objectToFollow.x < objectToMove.x # farther left
                            if objDetect.check_surrounding("left", objectToMove)  == false
                                attackerClass.facing = "left"
                                Move(vectorToMove,objectToMove,"left",speed,time)
                                
                            elsif objDetect.check_surrounding("left", objectToMove)  == true
                                if objectToFollow.y < objectToMove.y
                                    if objDetect.check_surrounding("up", objectToMove)  == false
                                        attackerClass.facing = "up"
                                        Move(vectorToMove,objectToMove,"up",speed,time)
                                    elsif objDetect.check_surrounding("up", objectToMove)  == true
                                        if objDetect.check_surrounding("down", objectToMove)  == false
                                            attackerClass.facing = "down"
                                            Move(vectorToMove,objectToMove,"down",speed,time)
                                        elsif objDetect.check_surrounding("down", objectToMove)  == true
                                            if objDetect.check_surrounding("right", objectToMove)  == false
                                                attackerClass.facing = "right"
                                                Move(vectorToMove,objectToMove,"right",speed,time)
                                            end
                                        end
                                    end
                                else
                                    if objDetect.check_surrounding("down", objectToMove)  == false
                                        attackerClass.facing = "down"
                                        Move(vectorToMove,objectToMove,"down",speed,time)
                                    elsif objDetect.check_surrounding("down", objectToMove)  == true
                                        if objDetect.check_surrounding("up", objectToMove)  == false
                                            attackerClass.facing = "up"
                                            Move(vectorToMove,objectToMove,"up",speed,time)
                                        elsif objDetect.check_surrounding("up", objectToMove)  == true
                                            if objDetect.check_surrounding("right", objectToMove)  == false
                                                attackerClass.facing = "right"
                                                Move(vectorToMove,objectToMove,"right",speed,time)
                                            end
                                        end
                                    end
                                end
                            end
                        elsif objectToFollow.x>objectToMove.x # farther right
                            if objDetect.check_surrounding("right", objectToMove)  == false
                                attackerClass.facing = "right"
                                Move(vectorToMove,objectToMove,"right",speed,time)
                                
                            elsif objDetect.check_surrounding("right", objectToMove)  == true
                                if objectToFollow.y < objectToMove.y
                                    if objDetect.check_surrounding("up", objectToMove)  == false
                                        attackerClass.facing = "up"
                                        Move(vectorToMove,objectToMove,"up",speed,time)
                                    elsif objDetect.check_surrounding("up", objectToMove)  == true
                                        if objDetect.check_surrounding("down", objectToMove)  == false
                                            attackerClass.facing = "down"
                                            Move(vectorToMove,objectToMove,"down",speed,time)
                                        elsif objDetect.check_surrounding("down", objectToMove)  == true
                                            if objDetect.check_surrounding("left", objectToMove)  == false
                                                attackerClass.facing = "left"
                                                Move(vectorToMove,objectToMove,"left",speed,time)
                                            end
                                        end
                                    end
                                else
                                    if objDetect.check_surrounding("down", objectToMove)  == false
                                        attackerClass.facing = "down"
                                        Move(vectorToMove,objectToMove,"down",speed,time)
                                    elsif objDetect.check_surrounding("down", objectToMove)  == true
                                        if objDetect.check_surrounding("up", objectToMove)  == false
                                            attackerClass.facing = "up"
                                            Move(vectorToMove,objectToMove,"up",speed,time)
                                        elsif objDetect.check_surrounding("up", objectToMove)  == true
                                            if objDetect.check_surrounding("left", objectToMove)  == false
                                                attackerClass.facing = "left"
                                                Move(vectorToMove,objectToMove,"left",speed,time)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    elsif ((objectToFollow.x-16) - objectToMove.x ).abs <= ((objectToFollow.y-16) - objectToMove.y).abs && (objectToFollow.y - objectToMove.y).abs <= range # In Range Y Dis Greater
                        if objectToFollow.y > objectToMove.y #farther down
                            if objDetect.check_surrounding("down", objectToMove)  == false
                                attackerClass.facing = "down"
                                Move(vectorToMove,objectToMove,"down",speed,time)
                                
                            elsif objDetect.check_surrounding("down", objectToMove)  == true
                                if objectToFollow.x >= objectToMove.x
                                    if objDetect.check_surrounding("right", objectToMove)  == false
                                        attackerClass.facing = "right"
                                        Move(vectorToMove,objectToMove,"right",speed,time)
                                    elsif objDetect.check_surrounding("right", objectToMove)  == true
                                        if objDetect.check_surrounding("left", objectToMove)  == false
                                            attackerClass.facing = "left"
                                            Move(vectorToMove,objectToMove,"left",speed,time)
                                        elsif objDetect.check_surrounding("left", objectToMove)  == true
                                            if objDetect.check_surrounding("up", objectToMove)  == false
                                                attackerClass.facing = "up"
                                                Move(vectorToMove,objectToMove,"up",speed,time)
                                            end
                                        end
                                    end
                                else
                                    if objDetect.check_surrounding("left", objectToMove)  == false
                                        attackerClass.facing = "left"
                                        Move(vectorToMove,objectToMove,"left",speed,time)
                                    elsif objDetect.check_surrounding("left", objectToMove)  == true
                                        if objDetect.check_surrounding("right", objectToMove)  == false
                                            attackerClass.facing = "right"
                                            Move(vectorToMove,objectToMove,"right",speed,time)
                                        elsif objDetect.check_surrounding("right", objectToMove)  == true
                                            if objDetect.check_surrounding("down", objectToMove)  == false
                                                attackerClass.facing = "down"
                                                Move(vectorToMove,objectToMove,"down",speed,time)
                                            end
                                        end
                                    end
                                end
                            end
                        elsif objectToFollow.y < objectToMove.y #farther up
                            if objDetect.check_surrounding("up", objectToMove)  == false
                                attackerClass.facing = "up"
                                Move(vectorToMove,objectToMove,"up",speed,time)
                                
                            elsif objDetect.check_surrounding("up", objectToMove)  == true
                                if objectToFollow.x >= objectToMove.x
                                    if objDetect.check_surrounding("right", objectToMove)  == false
                                        attackerClass.facing = "right"
                                        Move(vectorToMove,objectToMove,"right",speed,time)
                                    elsif objDetect.check_surrounding("right", objectToMove)  == true
                                        if objDetect.check_surrounding("left", objectToMove)  == false
                                            attackerClass.facing = "left"
                                            Move(vectorToMove,objectToMove,"left",speed,time)
                                        elsif objDetect.check_surrounding("left", objectToMove)  == true
                                            if objDetect.check_surrounding("down", objectToMove)  == false
                                                attackerClass.facing = "down"
                                                Move(vectorToMove,objectToMove,"down",speed,time)
                                            end
                                        end
                                    end
                                else
                                    if objDetect.check_surrounding("left", objectToMove)  == false
                                        attackerClass.facing = "left"
                                        Move(vectorToMove,objectToMove,"left",speed,time)
                                    elsif objDetect.check_surrounding("left", objectToMove)  == true
                                        if objDetect.check_surrounding("right", objectToMove)  == false
                                            attackerClass.facing = "right"
                                            Move(vectorToMove,objectToMove,"right",speed,time)
                                        elsif objDetect.check_surrounding("right", objectToMove)  == true
                                            if objDetect.check_surrounding("down", objectToMove)  == false
                                                attackerClass.facing = "down"
                                                Move(vectorToMove,objectToMove,"down",speed,time)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    elsif ((objectToFollow.y-16) - objectToMove.y).abs <= (range) && ((objectToFollow.x-16) - objectToMove.x ).abs <= (range) # In Range Else
                        if objectToFollow.y <= objectToMove.y #farther up
                            if objectToFollow.x >= objectToMove.x # up and right
                                if objDetect.check_surrounding("up", objectToMove)  == false
                                    attackerClass.facing = "up"
                                    Move(vectorToMove,objectToMove,"up",speed,time)
                                elsif objDetect.check_surrounding("up", objectToMove)  == true
                                    if objDetect.check_surrounding("right", objectToMove)  == false
                                        attackerClass.facing = "right"
                                        Move(vectorToMove,objectToMove,"right",speed,time)
                                    elsif objDetect.check_surrounding("right", objectToMove)  == true
                    
                                    end
                                end
                            elsif objectToFollow.x < objectToMove.x # up and left
                                if objDetect.check_surrounding("left", objectToMove)  == false
                                    attackerClass.facing = "left"
                                    Move(vectorToMove,objectToMove,"left",speed,time)
                                elsif objDetect.check_surrounding("left", objectToMove)  == true
                                    if objDetect.check_surrounding("up", objectToMove)  == false
                                        attackerClass.facing = "up"
                                        Move(vectorToMove,objectToMove,"up",speed,time)
                                    elsif objDetect.check_surrounding("up", objectToMove)  == true
                    
                                    end
                                end
                            end
                
                        elsif objectToFollow.y < objectToMove.y #farther down
                            if objectToFollow.x > objectToMove.x # down and right
                                if objDetect.check_surrounding("right", objectToMove)  == false
                                    attackerClass.facing = "right"
                                    Move(vectorToMove,objectToMove,"right",speed,time)
                                elsif objDetect.check_surrounding("right", objectToMove)  == true
                                    if objDetect.check_surrounding("down", objectToMove)  == false
                                        attackerClass.facing = "down"
                                        Move(vectorToMove,objectToMove,"down",speed,time)
                                    elsif objDetect.check_surrounding("down", objectToMove)  == true
                    
                                    end
                                end
                            elsif objectToFollow.x < objectToMove.x # down and left
                                if objDetect.check_surrounding("left", objectToMove)  == false
                                    attackerClass.facing = "left"
                                    Move(vectorToMove,objectToMove,"left",speed,time)
                                elsif objDetect.check_surrounding("left", objectToMove)  == true
                                    if objDetect.check_surrounding("down", objectToMove)  == false
                                        attackerClass.facing = "down"
                                        Move(vectorToMove,objectToMove,"down",speed,time)
                                    elsif objDetect.check_surrounding("down", objectToMove)  == true
                    
                                    end
                                end
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
    end
    def draw
    end
end
