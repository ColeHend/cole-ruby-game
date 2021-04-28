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
    def isAnEnemy(baddy,goody)
        goody.enemyGroups.each {|e|
        if baddy.battle.hateGroup == e
            return true
        end
        
        }
        return false
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
    
    def Follow(vectorToMove,attackerClass, objectToMove,atkType="melee",range=6*32,nearDist,objectToFollow,moveArray)
        @objectToFollow = objectToFollow
        lockedOn = false
        detectDist = range
        objDetect = MoveCollision.new
        speed = 0.25
        time = 10
        tileDetectW = 6
        moveNumber = 1

        moveLeft = ->(){
            moveNumber.times{
                attackerClass.facing = "left"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
        }
        moveRight = ->(){
            moveNumber.times{
                attackerClass.facing = "right"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
        }
        moveUp = ->(){
            moveNumber.times{
                attackerClass.facing = "up"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
        }
        moveDown = ->(){
            moveNumber.times{
                attackerClass.facing = "down"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
        }
        facingUp = ->(){ draw_character(objectToMove, "upStop",time)}
        facingDown = ->(){ draw_character(objectToMove, "downStop",time)}
        facingLeft = ->(){ draw_character(objectToMove, "leftStop",time)}
        facingRight = ->(){ draw_character(objectToMove, "rightStop",time)}
        if @objectToFollow.is_a?(GameObject) == false#|| @objectToFollow.is_a?(Event) == false
            if MoveCollision.new.check_inRange(objectToMove,detectDist ,false) == true
                theEnemy = MoveCollision.new.check_inRange(objectToMove,detectDist,true)
                if theEnemy.is_a?(Event)
                    if isAnEnemy(theEnemy,attackerClass.battle)
                        @objectToFollow = theEnemy.eventObject
                    end
                end
            end
        end
        if @objectToFollow.is_a?(GameObject) == true
            followAbsX = ((@objectToFollow.x+(@objectToFollow.w/2)) - (objectToMove.x+(objectToMove.w/2)) ).abs
            followAbsY = ((@objectToFollow.y+32) - (objectToMove.y+32) ).abs
            
            if objDetect.check_inRange(objectToMove,detectDist ,false) == true#in total range
                if objDetect.check_inRange(objectToMove,nearDist ,false) == true #is in close range
                    if followAbsY <= tileDetectW
                        if @objectToFollow.x < objectToMove.x
                            if moveArray.length < 1
                                moveArray.push(moveLeft)
                            end
                        elsif @objectToFollow.x > objectToMove.x
                            if moveArray.length < 1
                                moveArray.push(moveRight)
                            end
                        end
                    end
                    if followAbsX <= tileDetectW
                        if @objectToFollow.y < objectToMove.y
                            if moveArray.length < 1
                                moveArray.push(moveUp)
                            end
                        elsif @objectToFollow.y > objectToMove.y
                            if moveArray.length < 1
                                moveArray.push(moveDown)
                            end
                        end
                    end
                    
                elsif followAbsX <= tileDetectW && followAbsX > nearDist && followAbsY > nearDist # on vertical
                    if @objectToFollow.y < objectToMove.y#above
                        if objDetect.check_surrounding("up", objectToMove)  == false
                            moveArray.push(moveUp)
                        elsif objDetect.check_surrounding("up", objectToMove)  == true
                            if @objectToFollow.x > objectToMove.x
                                if objDetect.check_surrounding("left", objectToMove)
                                    moveArray.push(moveLeft)
                                end
                            elsif @objectToFollow.x < objectToMove.x
                                if objDetect.check_surrounding("right", objectToMove)
                                    moveArray.push(moveRight)
                                end
                            end
                        end
                    elsif @objectToFollow.y > objectToMove.y#below
                        if objDetect.check_surrounding("down", objectToMove)  == false
                            moveArray.push(moveDown)
                        elsif objDetect.check_surrounding("down", objectToMove)  == true
                            if @objectToFollow.x > objectToMove.x
                                if objDetect.check_surrounding("left", objectToMove)
                                    moveArray.push(moveLeft)
                                end
                            elsif @objectToFollow.x < objectToMove.x
                                if objDetect.check_surrounding("right", objectToMove)
                                    moveArray.push(moveRight)
                                end
                            end
                        end
                    end
                elsif followAbsY <= tileDetectW && followAbsX > nearDist && followAbsY > nearDist # on horizontal
                    if @objectToFollow.x < objectToMove.x#left
                        if objDetect.check_surrounding("left", objectToMove)  == false
                            moveArray.push(moveLeft)
                        elsif objDetect.check_surrounding("left", objectToMove)  == true
                            if @objectToFollow.y > objectToMove.y
                                if objDetect.check_surrounding("up", objectToMove)
                                    moveArray.push(moveUp)
                                end
                            elsif @objectToFollow.y < objectToMove.y
                                if objDetect.check_surrounding("down", objectToMove)
                                    moveArray.push(moveDown)
                                end
                            end
                        end
                    elsif @objectToFollow.x > objectToMove.x#right
                        if objDetect.check_surrounding("right", objectToMove)  == false
                            moveArray.push(moveRight)
                        elsif objDetect.check_surrounding("right", objectToMove)  == true
                            if @objectToFollow.y > objectToMove.y
                                if objDetect.check_surrounding("up", objectToMove)
                                    moveArray.push(moveUp)
                                end
                            elsif @objectToFollow.y < objectToMove.y
                                if objDetect.check_surrounding("down", objectToMove)
                                    moveArray.push(moveDown)
                                end
                            end
                        end
                    end
                elsif followAbsY > followAbsX# farther up or down
                    if @objectToFollow.y < objectToMove.y#up
                        if objDetect.check_surrounding("up", objectToMove)  == false
                            moveArray.push(moveUp)
                        elsif objDetect.check_surrounding("up", objectToMove)  == true
                            if @objectToFollow.x > objectToMove.x
                                if objDetect.check_surrounding("left", objectToMove)
                                    moveArray.push(moveLeft)
                                end
                            elsif @objectToFollow.x < objectToMove.x
                                if objDetect.check_surrounding("right", objectToMove)
                                    moveArray.push(moveRight)
                                end
                            end
                        end
                    elsif @objectToFollow.y > objectToMove.y#down
                        if objDetect.check_surrounding("down", objectToMove)  == false
                            moveArray.push(moveDown)
                        elsif objDetect.check_surrounding("down", objectToMove)  == true
                            if @objectToFollow.x > objectToMove.x
                                if objDetect.check_surrounding("left", objectToMove)
                                    moveArray.push(moveLeft)
                                end
                            elsif @objectToFollow.x < objectToMove.x
                                if objDetect.check_surrounding("right", objectToMove)
                                    moveArray.push(moveRight)
                                end
                            end
                        end
                    end
                elsif followAbsY < followAbsX#farther left or right
                    if @objectToFollow.x < objectToMove.x#left
                        if objDetect.check_surrounding("left", objectToMove)  == false
                            moveArray.push(moveLeft)
                        elsif objDetect.check_surrounding("left", objectToMove)  == true
                            if @objectToFollow.y > objectToMove.y
                                if objDetect.check_surrounding("up", objectToMove)
                                    moveArray.push(moveUp)
                                end
                            elsif @objectToFollow.y < objectToMove.y
                                if objDetect.check_surrounding("down", objectToMove)
                                    moveArray.push(moveDown)
                                end
                            end
                        end
                    elsif @objectToFollow.x > objectToMove.x#right
                        if objDetect.check_surrounding("right", objectToMove)  == false
                            moveArray.push(moveRight)
                        elsif objDetect.check_surrounding("right", objectToMove)  == true
                            if @objectToFollow.y > objectToMove.y
                                if objDetect.check_surrounding("up", objectToMove)
                                    moveArray.push(moveUp)
                                end
                            elsif @objectToFollow.y < objectToMove.y
                                if objDetect.check_surrounding("down", objectToMove)
                                    moveArray.push(moveDown)
                                end
                            end
                        end
                    end
                elsif objDetect.check_inRange(objectToMove,detectDist ,false) == false
                end
                defender = MoveCollision.new.check_inRange(objectToMove,detectDist,true)
                if defender.is_a?(Event) 
                    Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
                end
            end
        end
    end 
     
    def RandomMove(vectorToMove,objectToMove,moveDist,moveArray,facing,delayStart = Gosu::milliseconds())
        @randomNum = rand(4)
        speed = 0.25
        time = 10
        @delayStart = delayStart
        moveLeft = ->(){
            facing = "left"
            Move(vectorToMove,objectToMove,facing,speed,time)
        }
        moveRight = ->(){
            facing = "right"
            Move(vectorToMove,objectToMove,facing,speed,time)
        }
        moveUp = ->(){
            facing = "up"
            Move(vectorToMove,objectToMove,facing,speed,time)
        }
        moveDown = ->(){
            facing = "down"
            Move(vectorToMove,objectToMove,facing,speed,time)
        }
        moveWaitTime = (Gosu::milliseconds()/100 % 32)
        #puts("RandomMoveTime: #{moveWaitTime}")
        if (moveWaitTime == 0)
            moveNumber = moveDist
            case @randomNum
            when 0
                moveNumber.times{moveArray.push(moveRight) }
            when 1
                moveNumber.times{moveArray.push(moveUp) }
            when 2
                moveNumber.times{moveArray.push(moveLeft) }
            when 3
                moveNumber.times{ moveArray.push(moveDown)}
            end
            @delayStart = Gosu::milliseconds()
        end
    end   
    
    def triggerEvent(targetObject,activateType="SELECT")
        # targetObject is likely the player
        # returns the event in that direction if present
        collisionDetect = MoveCollision.new
        rangePlus = 8
        upEventCheck = collisionDetect.checkDir(targetObject,"up",rangePlus,true)
        downEventCheck = collisionDetect.checkDir(targetObject,"down",rangePlus,true)
        leftEventCheck = collisionDetect.checkDir(targetObject,"left",rangePlus,true)
        rightEventCheck = collisionDetect.checkDir(targetObject,"right",rangePlus,true)
        
        #check if input and colliding
        if collisionDetect.checkDir(targetObject,"up",rangePlus) == true
            activateType = upEventCheck
            if activateType.is_a?(Event)
                activateType = activateType.activateType
            end
        elsif collisionDetect.checkDir(targetObject,"down",rangePlus) == true
            activateType = downEventCheck
            if activateType.is_a?(Event)
                activateType = activateType.activateType
            end
        elsif collisionDetect.checkDir(targetObject,"left",rangePlus) == true
            activateType = leftEventCheck
            if activateType.is_a?(Event)
                activateType = activateType.activateType
            end
        elsif collisionDetect.checkDir(targetObject,"right",rangePlus) == true
            activateType = rightEventCheck
            if activateType.is_a?(Event)
                activateType = activateType.activateType
            end
        else
            activateType = "SELECT"
        end
        
        if activateType == "SELECT"
            if KB.key_pressed?(InputTrigger::SELECT)
                if collisionDetect.checkDir(targetObject,"up",rangePlus) == true
                    upEventCheck.activate_event
                elsif collisionDetect.checkDir(targetObject,"down",rangePlus) == true
                    downEventCheck.activate_event
                elsif collisionDetect.checkDir(targetObject,"left",rangePlus) == true
                    leftEventCheck.activate_event
                elsif collisionDetect.checkDir(targetObject,"right",rangePlus) == true
                    rightEventCheck.activate_event
                end
            end
        elsif activateType == "TOUCH"
            if collisionDetect.checkDir(targetObject,"up",rangePlus) == true
                upEventCheck.activate_event
            elsif collisionDetect.checkDir(targetObject,"down",rangePlus) == true
                downEventCheck.activate_event
            elsif collisionDetect.checkDir(targetObject,"left",rangePlus) == true
                leftEventCheck.activate_event
            elsif collisionDetect.checkDir(targetObject,"right",rangePlus) == true
                rightEventCheck.activate_event
            end
        end
    end
    def update
    end
    def draw
    end
end
