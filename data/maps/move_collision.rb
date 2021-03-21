require_relative "../files/animate.rb"
module MoveCollision
    class Vector2
        attr_accessor :x, :y
        def initialize(x, y)
            @x = x
            @y = y
        end
    end

    def overlap?(r1,r2)
        !(r1.first > r2.last || r1.last < r2.first)
    end
    def move_event(vector, objectToMove = self)
        #@collisionArray = collisionArray
        @randomNum = rand(4)
        @objectToMove = objectToMove
        @x = @objectToMove.x 
        @y = @objectToMove.y 
        @w = @objectToMove.w
        @h = @objectToMove.h
        @delayStart = 950
        @facing = ""
        @animate = true
        
        @currentMap =  $scene_manager.scene["map"].currentMap
        @events = @currentMap.events
        @currentMap = (@currentMap.map)
        @mWidth = @currentMap.width
        @mHeight = @currentMap.height


        #def checkDir(dir)vector,mWidth,mHeight,surroundingCheck) #need to change events movement ai from this
        #end
        
        def checkDir(dir,rangeBoost=0,evtReturn = false)
            @events.each {|event|
            @range = 33 + rangeBoost
            x = event.x
            y = event.y
            objectW = event.w
            objectH = event.h
            localObjectX = @x +x
            #puts(overlap?((x...(x+objectW)),(@x...(@x+@w))))
            #puts((x...(x+objectW)))
            #puts("^overlap?")
            case dir
                when "up"
                    if (@range+6) >= (y+(objectH) - (@y + @h)).abs && ((x) - @x).abs <= (@range-16) #up
                        if (overlap?(((y)...(y+objectH+8)),(@y...(@y+@h))) === true) && (overlap?(((x)...(x+objectW)),((@x)...(@x+@w))) === true)
                            if evtReturn == true
                                return event
                            else
                                return true
                            end
                        end
                    end
                when "down"
                    if @range >= (y+(16) - (@y + @h)).abs && ((x) - @x).abs <= (@range-16) #down
                        if (overlap?(((y)...(y+objectH)),(@y...(@y+@h))) === true) && (overlap?(((x)...(x+objectW)),((@x)...(@x+@w))) === true)
                            if evtReturn == true
                                return event
                            else
                                return true
                            end
                        end
                    end
                when "left"
                    if (@range-2 ) >= ((y) - @y).abs && ((x+objectW) - @x).abs <= (@range) #up
                        if (overlap?(((x)...(x+objectW)),((@x)...(@x+@w))) === true) && (overlap?(((y)...(y+objectH+8)),((@y)...(@y+@h))) === true)
                            if evtReturn == true
                                return event
                            else
                                return true
                            end 
                        end
                    end
                when "right"
                    if (@range-2 ) >= ((y) - @y).abs && (x - (@x + @w)).abs <= (@range) #up
                        if (overlap?(((x)...(x+objectW)),((@x)...(@x+@w))) === true) && (overlap?(((y)...(y+objectH+8)),(@y...(@y+@h))) === true)
                            if evtReturn == true
                                return event
                            else
                                return true
                            end
                        end
                    end
            end
            }
        end

        def check_surrounding(direction,player)
            #@x = player.x
            #@y = player.y 
            #@w = playerw
            #@h = player.h
            
                
                #puts(checkDir("up"))
                #puts("^checkdir(up)")
                case direction
                when "up"
                    if @y <= 32 #&& @facing == "up"
                        return true
                    elsif checkDir("up") == true#true collide
                        return true
                    else
                        return false
                    end
                when "down"
                    if @y == (@mHeight * 32-16)# && @facing == "down"
                        return true
                    elsif checkDir("down") == true#true collide
                        return true
                    else
                        return false
                    end
                when "left" 
                    if @x == 0 #&& @facing == "left"
                        return true
                    elsif checkDir("left") == true#true collide
                        return true
                    else
                        return false
                    end
                when "right" 
                    if @x >= (@mWidth * 32) #&& @facing == "right"
                        return true
                    elsif checkDir("right") == true#true collide
                        return true
                    else
                        return false
                    end
                end
            
            end

        def objectCollision(dir)
            player = $scene_manager.scene["player"].player
            #puts(check_surrounding(dir,player))
            #puts("^checked")
            @currentMap =  $scene_manager.scene["map"].currentMap.map
            #@currentMap.events.each {|event|
            
            
             check_surrounding(dir,player)
                #if checkDir(dir)
                  #  return false
                #end
            #else
               # return true
            #end
        end
        
        def eventRun(dir)
            case dir
            when "up"
                if KB.key_pressed?(InputTrigger::SELECT)
                    checkDir("up")
                end
            when "down"
                if KB.key_pressed?(InputTrigger::SELECT)
                    checkDir("down")
                end
            when "right"
                if KB.key_pressed?(InputTrigger::SELECT)
                    checkDir("right")
                end
            when "left"
                if KB.key_pressed?(InputTrigger::SELECT)
                    checkDir("left")
                end
            end
        end
        upCheck = check_surrounding("up",(self))
        downCheck = check_surrounding("down",self) 
        leftCheck = check_surrounding("left",self)
        rightCheck = check_surrounding("right",(self))
        
        event = ->(activateType="SELECT"){
            # returns the event in that direction if present
            upEventCheck = checkDir("up",0,true)
            downEventCheck = checkDir("down",0,true)
            leftEventCheck = checkDir("left",0,true)
            rightEventCheck = checkDir("right",0,true)
            #check if input and colliding
            if activateType == "SELECT"
                if KB.key_pressed?(InputTrigger::SELECT)
                    if checkDir("up") == true
                        upEventCheck.activate_event
                    elsif checkDir("down") == true
                        downEventCheck.activate_event
                    elsif checkDir("left") == true
                        leftEventCheck.activate_event
                    elsif checkDir("right") == true
                        rightEventCheck.activate_event
                    end
                end
            elsif activateType == "TOUCH"
                if checkDir("up") == true
                    upEventCheck.activate_event
                elsif checkDir("down") == true
                    downEventCheck.activate_event
                elsif checkDir("left") == true
                    leftEventCheck.activate_event
                elsif checkDir("right") == true
                    rightEventCheck.activate_event
                end
            end
        }
        move = -> (vector) {
            
            newXPos = @objectToMove.x + (vector.x * 4)
            newYPos = @objectToMove.y + (vector.y * 4)
            
            if vector.y > 0
                if objectCollision("down") != true
                    @objectToMove.x = newXPos
                    @objectToMove.y = newYPos
                    draw_character(@objectToMove, "down",5)
                end
            elsif vector.y < 0
                if objectCollision("up") != true
                    @objectToMove.x = newXPos
                    @objectToMove.y = newYPos
                    draw_character(@objectToMove, "up",5)
                end
            elsif vector.x > 0
                if objectCollision("right") != true
                    @objectToMove.x = newXPos
                    @objectToMove.y = newYPos
                    draw_character(@objectToMove, "right",5)
                end
            elsif vector.x < 0
                if objectCollision("left") != true
                    @objectToMove.x = newXPos
                    @objectToMove.y = newYPos
                    draw_character(@objectToMove, "left",5)
                end
            end
        }
        
        moveRandom = ->(randomDir){
            @delayStop = Gosu.milliseconds
            if (@delayStop - @delayStart < 1000)
                @animate = true
                
                case randomDir
                when 0
                    #@objectToMove.set_animation(0)
                when 1
                    moveRight.call(3)
                when 2
                    moveUp.call(3)
                when 3
                    moveLeft.call(3)
                when 4
                    moveDown.call(3)
                end
            end
        }
        facePlayer = ->(sight=300){
           x = $scene_manager.scene["player"].x
           y = $scene_manager.scene["player"].y
           @range = 400
           if (x - @x).abs <= @range && (y - @y).abs <= @range
            if (y - @y) <= 0  && (x - @x) >= 0
               if (x-@x).abs <= (y-@y).abs
                @objectToMove.set_animation(12)
               else @objectToMove.set_animation(8)
               end
            elsif  (y - @y) >= 0 && (x - @x) <= 0
               if (x-@x).abs <= (y-@y).abs
                @objectToMove.set_animation(0)
               else @objectToMove.set_animation(4)
               end
            end
           end
        }
        faceFollowPlayer = ->(followDist=3,sight=6*32,randDir = 1){
            x = $scene_manager.scene["player"].x
            y = $scene_manager.scene["player"].y
            lockedOn = false 
            @range = 400
            if @range > (y - @y).abs && (x - @x).abs < @range
           #     @delayStop = Gosu.milliseconds
           #     if (@delayStop - @delayStart < 10000)
           #         randDir = rand(4)
           #     end

           #     case randDir
           #     when 0
           #         draw_character(@objectToMove, "upStop",2)
           #         @facing = "up"
           #     when 1
           #         draw_character(@objectToMove, "downStop",2)
           #         @facing = "down"
           #     when 2
           #         draw_character(@objectToMove, "leftStop",2)
           #         @facing = "left"
           #     when 3
           #         draw_character(@objectToMove, "rightStop",2)
           #         @facing = "right"
           #     end
           # end

            case @facing
            when "up"
                if checkDir("up",sight)
                    if (y - @y).abs >= (x - @x).abs # player X Closer Then Y
                        if objectCollision("up") != true && y > @y
                            moveUp.call(1)
                        else
                            if x <= @x # player to the left
                                if objectCollision("left") != true
                                    moveLeft.call(1)
                                else
                                    if objectCollision("up") != true
                                        moveUp.call(1)
                                    end
                                end
                            elsif x > @x #player to the right
                                if objectCollision("right") != true
                                    moveRight.call(1)
                                else
                                    if objectCollision("up") != true
                                        moveUp.call(1)
                                    end
                                end
                            end
                        end
                    else
                        if x > @x
                            if objectCollision("right") != true
                                moveRight.call(1)
                            else
                                if objectCollision("up") != true
                                    moveUp.call(1)
                                end
                            end
                        else
                            if objectCollision("left") != true
                                moveLeft.call(1)
                            else
                                if objectCollision("up") != true
                                    moveUp.call(1)
                                end
                            end
                        end
                    end
                end
            when "down"
                if checkDir("down",sight)
                    if (y - @y).abs > (x - @x).abs # player X Closer Then Y
                        if objectCollision("down") != true && y > @y
                            moveDown.call(1)
                        else
                            if x <= @x # player to the left
                                if objectCollision("left") != true
                                    moveLeft.call(1)
                                else
                                    if objectCollision("down") != true
                                        moveDown.call(1)
                                    end
                                end
                            elsif x > @x #player to the right
                                if objectCollision("right") != true
                                    moveRight.call(1)
                                else
                                    if objectCollision("down") != true
                                        moveDown.call(1)
                                    end
                                end
                            end
                        end
                    else
                        if x > @x
                            if objectCollision("right") != true
                                moveRight.call(1)
                            else
                                if objectCollision("down") != true
                                    moveUp.call(1)
                                end
                            end
                        else
                            if objectCollision("left") != true
                                moveLeft.call(1)
                            else
                                if objectCollision("down") != true
                                    moveUp.call(1)
                                end
                            end
                        end
                    end
                end
            when "left"
                if checkDir("left",sight)

                end
            when "right"
                if checkDir("right",sight)

                end
            end
        end
        }
        followPlayer = ->(sight=2,betweenMove=100){
            @delayStop = Gosu.milliseconds
            #if (@delayStop - @delayStart < betweenMove)
           x = $scene_manager.scene["player"].x
           y = $scene_manager.scene["player"].y
           @range = sight
            if (x - @x).abs > (y - @y).abs && (x - @x).abs > @range  #Range
                    if x < @x && @facing == "left" #player to left
                        if objectCollision("left") != true
                            moveLeft.call(1)
                        elsif objectCollision("left") != true
                            if y > @y # player below
                                if objectCollision("down") != true
                                moveDown.call(1)
                                elsif objectCollision("up") != true
                                moveUp.call(1)
                                end
                            elsif y < @y #player above
                                if objectCollision("up") != true
                                moveUp.call(1)
                                elsif objectCollision("down") != true
                                moveDown.call(1)
                                end
                            end
                        end
                    elsif x>@x && @facing == "right" #player to right
                        if objectCollision("right") != true
                            moveRight.call(1)
                        elsif objectCollision("right") != true
                            if y > @y # player below
                                if objectCollision("down") != true
                                moveDown.call(1)
                                elsif objectCollision("up") != true
                                moveUp.call(1)
                                end
                            elsif y < @y #player above
                                if objectCollision("up") != true
                                moveUp.call(1)
                                elsif objectCollision("down") != true
                                moveDown.call(1)
                                end
                            end
                        end
                    end
                elsif (x - @x).abs < (y - @y).abs && (y - @y).abs > @range   #Range
                    if y > @y && @facing == "down" #player to below
                        if objectCollision("down") != true
                            moveDown.call(1)
                        elsif objectCollision("down") != true
                            if x > @x # player right
                                if objectCollision("right") != true
                                moveRight.call(1)
                                elsif objectCollision("left") != true
                                moveLeft.call(1)
                                end
                            else #player left
                                if objectCollision("left") != true
                                moveLeft.call(1)
                                elsif objectCollision("right") != true
                                moveRight.call(1)
                                end
                            end
                        end
                    elsif y < @y && @facing == "up" #player to above
                        if objectCollision("up") != true
                            moveUp.call(1)
                        elsif objectCollision("up") != true
                            if x > @x # player right
                                if objectCollision("right") != true
                                moveRight.call(1)
                                elsif objectCollision("left") != true
                                moveLeft.call(1)
                                end
                            else #player left
                                if objectCollision("left") != true
                                moveLeft.call(1)
                                elsif objectCollision("right") != true
                                moveRight.call(1)
                                end
                            end
                        end
                    end
                elsif (y - @y).abs <= (@range) && (x - @x).abs <= (@range)
                   # @animate = false
            end
        #end
         }
         move.call(vector)
         event.call()
         moveType = "none"
        case moveType
        when "none"
            @animate = false 
        when "up"
            moveUp.call(distance)
        when "down"
            moveDown.call(distance)
        when "left"
            moveLeft.call(distance)
        when "right" 
            moveRight.call(distance)
        when "eventRun"
            eventRun(@facing)
        when "random"
            @delayStart = Gosu.milliseconds
            if (Gosu.milliseconds / 175 % 16 == 0)
                moveRandom.call(@randomNum)
            end
        when "facePlayer"
            @animate = false
            facePlayer.call(distance)
        when "followPlayer"
            @delayStart = Gosu.milliseconds
            followPlayer.call(distance)
        when "faceFollowPlayer"
            @delayStart = Gosu.milliseconds
            faceFollowPlayer.call()
        else
            @animate = false 
        end
        if @animate == false
            case @facing
            when "up"
                draw_character(@objectToMove, "upStop",2)
            when "down"
                draw_character(@objectToMove, "downStop",2)
            when "left"
                draw_character(@objectToMove, "leftStop",2)
            when "right"
                draw_character(@objectToMove, "rightStop",2)
            end
        end
    end
end
