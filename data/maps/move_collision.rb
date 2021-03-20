require_relative "../files/animate.rb"
module MoveCollision
    def overlap?(r1,r2)
        !(r1.first > r2.last || r1.last < r2.first)
    end
    def move_event(moveType,distance,objectToMove = self, facing = "down")
        #@collisionArray = collisionArray
        @objectToMove = objectToMove
        @x = @objectToMove.x 
        @y = @objectToMove.y 
        @w = @objectToMove.w
        @h = @objectToMove.h
        @delayStart = 950
        @facing = facing
        @animate = true
        
        @currentMap =  $scene_manager.scene["map"].currentMap
        @events = @currentMap.events
        @currentMap = (@currentMap.map)
        @mWidth = @currentMap.width
        @mHeight = @currentMap.height

        #def checkDir(dir)direction,mWidth,mHeight,surroundingCheck) #need to change events movement ai from this
        #end
        
        def checkDir(dir="down",evtReturn = false)
            @events.each {|event|
            @range = 26
            x = event.x
            y = event.y
            objectW = event.w
            objectH = event.h
            #puts(overlap?((x...(x+objectW)),(@x...(@x+@w))))
            #puts((x...(x+objectW)))
            #puts("^overlap?")
            case dir
                when "up"
                    if @range >= ((y+objectH) - @y).abs && (((x) - @x)).abs <= (@range) #up
                        if (overlap?(((y)...(y+objectH)),(@y...(@y+@h))) === true) && (overlap?(((x+4)...(x+objectW)),((@x)...(@x+@w))) === true)
                            if evtReturn == true
                                return event
                            else
                                return true
                            end
                        end
                    end
                when "down"
                    if @range >= (y - (@y + @h)).abs && ((x) - @x).abs <= (@range) #down
                        if (overlap?(((y+16)...(y+objectH)),(@y...(@y+@h))) === true) && (overlap?(((x+4)...(x+objectW)),((@x)...(@x+@w))) === true)
                            if evtReturn == true
                                return event
                            else
                                return true
                            end
                        end
                    end
                when "left"
                    if (@range ) >= ((y+objectW/2) - @y).abs && ((x+objectW) - @x).abs <= (@range) #up
                        if (overlap?(((x)...(x+objectW)),((@x)...(@x+@w))) === true) && (overlap?(((y)...(y+objectH)),((@y)...(@y+@h))) === true)
                            if evtReturn == true
                                return event
                            else
                                return true
                            end 
                        end
                    end
                when "right"
                    if (@range ) >= ((y+objectW/2) - @y).abs && (x - (@x + @w)).abs <= (@range) #up
                        if (overlap?(((x)...(x+objectW)),((@x)...(@x+@w))) === true) && (overlap?(((y)...(y+objectH)),(@y...(@y+@h))) === true)
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
                    if @y <= 32 && @facing == "up"
                        return true
                    elsif checkDir("up") == true#true collide
                        return true
                    else
                        return false
                    end
                when "down"
                    if @y == (@mHeight * 32 - 16) && @facing == "down"
                        return true
                    elsif checkDir("down") == true#true collide
                        return true
                    else
                        return false
                    end
                when "left" 
                    if @x == 0 && @facing == "left"
                        return true
                    elsif checkDir("left") == true#true collide
                        return true
                    else
                        return false
                    end
                when "right" 
                    if @x >= (@mWidth * 32) && @facing == "right"
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
        #}
            
            
        end
        
        upCheck = check_surrounding("up",(self))
        downCheck = check_surrounding("down",self) 
        leftCheck = check_surrounding("left",self)
        rightCheck = check_surrounding("right",(self))

        moveUp = ->(distance=1,optional=true){ 
            for a in (1..distance) do
                if optional
                    @facing = "up"
                    #puts(objectCollision("up"))
                    if objectCollision("up") != true
                        draw_character(@objectToMove, "up",5)
                        @objectToMove.y = (@objectToMove.y - 4)
                    else
                        @objectToMove.set_animation(12)
                    end
                end
            end
        }
        moveDown = ->(distance=1,optional=true){
            #puts(objectCollision("down"))
            #puts("^collision down")
            for a in (1..distance) do
                @facing = "down"
                if objectCollision("down") != true
                    draw_character(@objectToMove, "down",5) 
                    @objectToMove.y = (@objectToMove.y + 4)
                else
                    @objectToMove.set_animation(0)
                end
            end
        }
        moveRight = ->(distance=1){
            for a in (1..distance) do
                @facing = "right"
                if objectCollision("right") != true
                    draw_character(@objectToMove, "right",5) 
                    @objectToMove.x = ( @objectToMove.x + 4)
                else
                    @objectToMove.set_animation(8)
                end
            end
        }
        moveLeft = ->(distance=1){ 
            for a in (1..distance) do
                @facing = "left"
                if objectCollision("left") != true
                    draw_character(@objectToMove, "left",5)
                    @objectToMove.x = (@objectToMove.x - 4)
                else
                    @objectToMove.set_animation(4)
                end
            end
        }
        
        moveRandom = ->(){
            @delayStop = Gosu.milliseconds
            if (@delayStop - @delayStart < 1000)
                @animate = true
                randomDir = rand(4)
                case randomDir
                when 0
                    @objectToMove.set_animation(0)
                when 1
                    moveRight.call(1)
                when 2
                    moveUp.call(1)
                when 3
                    moveLeft.call(1)
                when 4
                    moveDown.call(1)
                end
            else
                @objectToMove.set_animation(0)
            end
        }
        facePlayer = ->(sight=6){
           x = $scene_manager.scene["player"].x
           y = $scene_manager.scene["player"].y
           @range = sight
           if (x - @x).abs <= @range && (y - @y).abs <= @range
            if (y - @y) < 0  && (x - @x) > 0
               if (x-@x).abs < (y-@y).abs
                @objectToMove.set_animation(12)
               else @objectToMove.set_animation(8)
               end
            elsif  (y - @y) > 0 && (x - @x) < 0
               if (x-@x).abs < (y-@y).abs
                @objectToMove.set_animation(0)
               else @objectToMove.set_animation(4)
               end
            end
           end
        }
        faceFollowPlayer = ->(followDist=3,sight=6,randDir = 1){
            x = $scene_manager.scene["player"].x
            y = $scene_manager.scene["player"].y
            lockedOn = false 
            if @range > (y - @y).abs && (x - @x).abs < @range
                @delayStop = Gosu.milliseconds
                if (@delayStop - @delayStart < 10000)
                    randDir = rand(4)
                end

                case randDir
                when 0
                    draw_character(@objectToMove, "upStop",2)
                    @facing = "up"
                when 1
                    draw_character(@objectToMove, "downStop",2)
                    @facing = "down"
                when 2
                    draw_character(@objectToMove, "leftStop",2)
                    @facing = "left"
                when 3
                    draw_character(@objectToMove, "rightStop",2)
                    @facing = "right"
                end
            end

            case @facing
            when "up"
                if lookingForPlayer(sight,"up")
                    if (y - @y).abs >= (x - @x).abs # player X Closer Then Y
                        if objectCollision("up") != true
                            moveUp.call(1)
                        else
                            if x <= @x # player to the left
                                if objectCollision("left") != true
                                    moveLeft.call(1)
                                else
                                    if objectCollision("right") != true
                                        moveRight.call(1)
                                    end
                                end
                            elsif x > @x #player to the right
                                if objectCollision("right") != true
                                    moveRight.call(1)
                                else
                                    if objectCollision("left") != true
                                        moveLeft.call(1)
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
                if lookingForPlayer(sight,"down")
                    if (y - @y).abs > (x - @x).abs # player X Closer Then Y
                        if objectCollision("down") != true
                            moveDown.call(1)
                        else
                            if x <= @x # player to the left
                                if objectCollision("left") != true
                                    moveLeft.call(1)
                                else
                                    if objectCollision("right") != true
                                        moveRight.call(1)
                                    end
                                end
                            elsif x > @x #player to the right
                                if objectCollision("right") != true
                                    moveRight.call(1)
                                else
                                    if objectCollision("left") != true
                                        moveLeft.call(1)
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
                if lookingForPlayer(sight,"left")

                end
            when "right"
                if lookingForPlayer(sight,"right")

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
        when "random"
            @delayStart = Gosu.milliseconds
            if (Gosu.milliseconds / 175 % 16 == 0)
                moveRandom.call()
            end
        when "facePlayer"
            @animate = false
            facePlayer.call(distance)
        when "followPlayer"
            @delayStart = Gosu.milliseconds
            followPlayer.call(distance)
        when "evtUp"
            checkDir("up")
        when "evtDown"
            checkDir("down")
        when "evtRight"
            checkDir("right")
        when "evtLeft"
            checkDir("left")
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
