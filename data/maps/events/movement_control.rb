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
    def buildPath(objectToMove,objectToFollow)
       #----------------------------------------------------------
       followAbsX = ((objectToFollow.x+(objectToFollow.w/2)) - (objectToMove.x+(objectToMove.w/2)) ).abs #g(n) exact distance y
       followAbsY = ((objectToFollow.y+((objectToFollow.h/4)*3)) - (objectToMove.y+((objectToMove.h/4)*3)) ).abs#g(n) exact distance x
        def inVectorArray(objectToMove)
           vectorArr = MoveCollision.new.vectorArray
           vectorArr.each_with_index{|impass,index|
               if objectToMove.x == impass.x && objectToMove.y == impass.y
                   return true
               end
           }
           return false
        end
       
       vectorFollow = Vector2.new(objectToFollow.x/32,objectToFollow.y/32)
       vectorToMove = Vector2.new(objectToMove.x/32,objectToMove.y/32)

       maxAbs = [followAbsX,followAbsY].max

       path = Array.new
       newPath = []
       theThread = Thread.new{
       until path[0] != nil do
        
           newVectorToMove = vectorToMove
           if followAbsX == maxAbs
               if vectorFollow.x < newVectorToMove.x # left
                   if inVectorArray(newVectorToMove.x-1) == false
                    
                       newVectorToMove.x -= 1
                       newPath.push("left")
                   elsif inVectorArray(newVectorToMove.x-1) == true
                       if vectorFollow.y < newVectorToMove.y # up
                           if inVectorArray(newVectorToMove.y-1) == false
                               newVectorToMove.y -= 1
                               newPath.push("up")
                           end
                       elsif vectorFollow.y > newVectorToMove.y # down
                           if inVectorArray(newVectorToMove.y+1) == false
                               newVectorToMove.y += 1
                               newPath.push("down")
                           end
                       end
                   end
               elsif vectorFollow.x > newVectorToMove.x # right
                   if inVectorArray(newVectorToMove.x+1) == false
                       newVectorToMove.x += 1
                       newPath.push("right")
                   elsif inVectorArray(newVectorToMove.x+1) == true
                       if vectorFollow.y < newVectorToMove.y # up
                           if inVectorArray(newVectorToMove.y-1) == false
                               newVectorToMove.y -= 1
                               newPath.push("up")
                           end
                       elsif vectorFollow.y > newVectorToMove.y # down
                           if inVectorArray(newVectorToMove.y+1) == false
                               newVectorToMove.y += 1
                               newPath.push("down")
                           end
                       end
                   end
               end
           elsif followAbsY == maxAbs
               if vectorFollow.y < newVectorToMove.y # up
                   if inVectorArray(newVectorToMove.y-1) == false
                       newVectorToMove.y -= 1
                       newPath.push("up")
                   elsif inVectorArray(newVectorToMove.y-1) == true
                       if vectorFollow.x < newVectorToMove.x # left
                           if inVectorArray(newVectorToMove.x-1) == false
                               newVectorToMove.x -= 1
                               newPath.push("left")
                           end
                       elsif vectorFollow.x > newVectorToMove.x # right
                           if inVectorArray(newVectorToMove.x+1) == false
                               newVectorToMove.x += 1
                               newPath.push("right")
                           end
                       end
                   end
               elsif vectorFollow.y > newVectorToMove.y # down
                   if inVectorArray(newVectorToMove.y+1) == false
                       newVectorToMove.y += 1
                       newPath.push("down")
                   elsif inVectorArray(newVectorToMove.y+1) == true
                       if vectorFollow.x < newVectorToMove.x # left
                           if inVectorArray(newVectorToMove.x-1) == false
                               newVectorToMove.x -= 1
                               newPath.push("left")
                           end
                       elsif vectorFollow.x > newVectorToMove.x # right
                           if inVectorArray(newVectorToMove.x+1) == false
                               newVectorToMove.x += 1
                               newPath.push("right")
                           end
                       end
                   end
               end
           else
           end
           if newVectorToMove.x == vectorFollow.x && newVectorToMove.y == vectorFollow.y
            puts("run")
               path.push(newPath[0])
               self.close
               return newPath[0]
               
           end
       end}
       #---------------------------------------------------------------- 
    end
    def newFollow(attackerClass,objectToMove,vectorToMove,objectToFollow,moveArray)
        if objectToFollow != nil
            speed = 0.25
            time = 10
            moveLeft = ->(){
                attackerClass.facing = "left"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
            moveRight = ->(){
                attackerClass.facing = "right"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
            moveUp = ->(){
                attackerClass.facing = "up"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
            moveDown = ->(){
                attackerClass.facing = "down"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
            toMoveDirection = buildPath(objectToMove,objectToFollow)
            puts("toMoveDirection: #{toMoveDirection}")
            case toMoveDirection
                when "up"
                    moveArray.push(moveUp)
                when "down"
                    moveArray.push(moveDown)
                when "left"
                    moveArray.push(moveLeft)
                when "right"
                    moveArray.push(moveRight)
            end
        end
    end
    def Follow(vectorToMove,attackerClass, objectToMove,range=6*32,objectToFollow=nil,moveArray=[],speed=0.25)
        @objectToFollow = objectToFollow
        lockedOn = false
        detectDist = range
        nearDist = (range / 2)
        superClose = 0
        objDetect = MoveCollision.new
        speed = 0.5
        time = 10
        tileDetectW = 6
        moveNumber = 1
        upEventCheck = objDetect.checkDir(objectToMove,"up",superClose,true)
        downEventCheck = objDetect.checkDir(objectToMove,"down",superClose,true)
        leftEventCheck = objDetect.checkDir(objectToMove,"left",superClose,true)
        rightEventCheck = objDetect.checkDir(objectToMove,"right",superClose,true)
        meleeRange = attackerClass.battle.weapon.range
            if attackerClass.battle.currentSpell.is_a?(Magic) == true
                spellRange = attackerClass.battle.currentSpell.range
            else
                spellRange = 30
            end
            if meleeRange > spellRange
                closestDist = meleeRange
            elsif meleeRange < spellRange
                closestDist = spellRange
            else
                closestDist = 32
            end
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
        facingRight = ->(){ draw_character(objectToMove, "rightStop",time)} # build path row by row up to them
        
        if @objectToFollow.is_a?(GameObject) == true
            followAbsX = ((@objectToFollow.x+(@objectToFollow.w/2)) - (objectToMove.x+(objectToMove.w/2)) ).abs #g(n) exact distance y
            followAbsY = ((@objectToFollow.y+32) - (objectToMove.y+32) ).abs#g(n) exact distance x
            
            if objDetect.check_inRange(objectToMove,detectDist ,false) == true#in total range
                if followAbsY > followAbsX# farther up or down
                    if @objectToFollow.y <= objectToMove.y#up
                        if objDetect.check_surrounding("up",objectToMove) == false
                            moveArray.push(moveUp)
                        elsif objDetect.check_surrounding("up",objectToMove) == true
                            if attackerClass.facing == "left"
                                if objDetect.check_surrounding("left",objectToMove) == false
                                    moveArray.push(moveLeft)
                                end
                            elsif attackerClass.facing == "right"
                                if objDetect.check_surrounding("right",objectToMove) == false
                                    moveArray.push(moveRight)
                                end
                            elsif @objectToFollow.x < objectToMove.x#couldadd
                                if objDetect.check_surrounding("left",objectToMove) == false
                                    moveArray.push(moveLeft)
                                end
                            elsif @objectToFollow.x > objectToMove.x
                                if objDetect.check_surrounding("right",objectToMove) == false
                                    moveArray.push(moveRight)
                                end
                            end
                        end
                    elsif @objectToFollow.y > objectToMove.y#down
                        if objDetect.check_surrounding("down",objectToMove) == false
                            moveArray.push(moveDown)
                        elsif objDetect.check_surrounding("down",objectToMove) == true
                            if attackerClass.facing == "left"
                                if objDetect.check_surrounding("left",objectToMove) == false
                                    moveArray.push(moveLeft)
                                end
                            elsif attackerClass.facing == "right"
                                if objDetect.check_surrounding("right",objectToMove) == false
                                    moveArray.push(moveRight)
                                end
                            elsif @objectToFollow.x < objectToMove.x#couldadd
                                if objDetect.check_surrounding("left",objectToMove) == false
                                    moveArray.push(moveLeft)
                                end
                            elsif @objectToFollow.x > objectToMove.x
                                if objDetect.check_surrounding("right",objectToMove) == false
                                    moveArray.push(moveRight)
                                end
                            end
                        end
                    end
                elsif followAbsY < followAbsX#farther left or right
                    if @objectToFollow.x < objectToMove.x#left
                        if objDetect.check_surrounding("left",objectToMove) == false
                            moveArray.push(moveLeft)
                        elsif objDetect.check_surrounding("left",objectToMove) == true
                            if attackerClass.facing == "up"
                                if objDetect.check_surrounding("up",objectToMove) == false
                                    moveArray.push(moveUp)
                                end
                            elsif attackerClass.facing == "down"
                                if objDetect.check_surrounding("down",objectToMove) == false
                                    moveArray.push(moveDown)
                                end
                            elsif @objectToFollow.y <= objectToMove.y#couldadd
                                if objDetect.check_surrounding("up",objectToMove) == false
                                    moveArray.push(moveUp)
                                end
                            elsif @objectToFollow.y > objectToMove.y
                                if objDetect.check_surrounding("down",objectToMove) == false
                                    moveArray.push(moveDown)
                                end
                            end
                        end
                    elsif @objectToFollow.x > objectToMove.x#right
                        if objDetect.check_surrounding("right",objectToMove) == false
                            moveArray.push(moveRight)
                        elsif objDetect.check_surrounding("right",objectToMove) == true
                            if attackerClass.facing == "up"
                                if objDetect.check_surrounding("up",objectToMove) == false
                                    moveArray.push(moveUp)
                                end
                            elsif attackerClass.facing == "down"
                                if objDetect.check_surrounding("down",objectToMove) == false
                                    moveArray.push(moveDown)
                                end
                            elsif @objectToFollow.y <= objectToMove.y#couldadd
                                if objDetect.check_surrounding("up",objectToMove) == false
                                    moveArray.push(moveUp)
                                end
                            elsif @objectToFollow.y > objectToMove.y
                                if objDetect.check_surrounding("down",objectToMove) == false
                                    moveArray.push(moveDown)
                                end
                            end
                        end
                    end
                elsif objDetect.check_inRange(objectToMove,detectDist ,false) == true && followAbsY <= tileDetectW#is in close range
                    if @objectToFollow.x < objectToMove.x
                        if moveArray.length < 1
                            if objDetect.check_surrounding("left",objectToMove) == false
                                moveArray.push(moveLeft)
                            elsif objDetect.check_surrounding("left",objectToMove) == true
                                if objDetect.check_surrounding("up",objectToMove) == false
                                    moveArray.push(moveUp)
                                elsif objDetect.check_surrounding("up",objectToMove) == false
                                    if objDetect.check_surrounding("down",objectToMove) == false
                                        moveArray.push(moveDown)
                                    end
                                end 
                            end
                        end
                    elsif @objectToFollow.x > objectToMove.x
                        if moveArray.length < 1
                            if objDetect.check_surrounding("right",objectToMove) == false
                                moveArray.push(moveRight)
                            elsif objDetect.check_surrounding("right",objectToMove) == false
                                if objDetect.check_surrounding("up",objectToMove) == false
                                    moveArray.push(moveUp)
                                elsif objDetect.check_surrounding("up",objectToMove) == false
                                    if objDetect.check_surrounding("down",objectToMove) == false
                                        moveArray.push(moveDown)
                                    end
                                end 
                            end
                        end
                    end
                elsif objDetect.check_inRange(objectToMove,detectDist ,false) == true && followAbsX <= tileDetectW
                    if @objectToFollow.y < objectToMove.y
                        if moveArray.length < 1
                            if objDetect.check_surrounding("up",objectToMove) == false
                                moveArray.push(moveUp)
                            elsif objDetect.check_surrounding("up",objectToMove) == false
                                if objDetect.check_surrounding("right",objectToMove) == false
                                    moveArray.push(moveRight)
                                elsif objDetect.check_surrounding("right",objectToMove) == false
                                    if objDetect.check_surrounding("left",objectToMove) == false
                                        moveArray.push(moveLeft)
                                    end
                                end
                            end
                        end
                    elsif @objectToFollow.y > objectToMove.y
                        if moveArray.length < 1
                            if objDetect.check_surrounding("down",objectToMove) == false
                                moveArray.push(moveDown)
                            elsif objDetect.check_surrounding("down",objectToMove) == false
                                if objDetect.check_surrounding("right",objectToMove) == false
                                    moveArray.push(moveRight)
                                elsif objDetect.check_surrounding("right",objectToMove) == false
                                    if objDetect.check_surrounding("left",objectToMove) == false
                                        moveArray.push(moveLeft)
                                    end
                                end
                            end
                        end
                    end
                else
                    Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
                end
                defender = MoveCollision.new.check_inRange(objectToMove,detectDist,true)
                if defender.is_a?(Event) 
                    #Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
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
    
    def triggerEvent(targetEvent,activateType="SELECT")
        # targetEvent is likely the player
        # returns the event in that direction if present
        collisionDetect = MoveCollision.new
        rangePlus = 8
        upEventCheck = collisionDetect.checkDir(targetEvent,"up",rangePlus,true)
        downEventCheck = collisionDetect.checkDir(targetEvent,"down",rangePlus,true)
        leftEventCheck = collisionDetect.checkDir(targetEvent,"left",rangePlus,true)
        rightEventCheck = collisionDetect.checkDir(targetEvent,"right",rangePlus,true)
        
        #check if input and colliding
        if collisionDetect.checkDir(targetEvent,"up",rangePlus) == true
            activateType = upEventCheck
            if activateType.is_a?(Event)
                activateType = activateType.activateType
            end
        elsif collisionDetect.checkDir(targetEvent,"down",rangePlus) == true
            activateType = downEventCheck
            if activateType.is_a?(Event)
                activateType = activateType.activateType
            end
        elsif collisionDetect.checkDir(targetEvent,"left",rangePlus) == true
            activateType = leftEventCheck
            if activateType.is_a?(Event)
                activateType = activateType.activateType
            end
        elsif collisionDetect.checkDir(targetEvent,"right",rangePlus) == true
            activateType = rightEventCheck
            if activateType.is_a?(Event)
                activateType = activateType.activateType
            end
        else
            activateType = "SELECT"
        end
        
        if activateType == "SELECT"
            if KB.key_pressed?(InputTrigger::SELECT)
                if collisionDetect.checkDir(targetEvent,"up",rangePlus) == true
                    upEventCheck.activate_event
                elsif collisionDetect.checkDir(targetEvent,"down",rangePlus) == true
                    downEventCheck.activate_event
                elsif collisionDetect.checkDir(targetEvent,"left",rangePlus) == true
                    leftEventCheck.activate_event
                elsif collisionDetect.checkDir(targetEvent,"right",rangePlus) == true
                    rightEventCheck.activate_event
                end
            end
        elsif activateType == "TOUCH"
            if collisionDetect.checkDir(targetEvent,"up",rangePlus) == true
                upEventCheck.activate_event
            elsif collisionDetect.checkDir(targetEvent,"down",rangePlus) == true
                downEventCheck.activate_event
            elsif collisionDetect.checkDir(targetEvent,"left",rangePlus) == true
                leftEventCheck.activate_event
            elsif collisionDetect.checkDir(targetEvent,"right",rangePlus) == true
                rightEventCheck.activate_event
            end
        end
    end
    def update
    end
    def draw
    end
end
