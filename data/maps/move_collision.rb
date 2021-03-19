require_relative "../files/animate.rb"
module MoveCollision
    def move_event(collisionArray,moveType,distance,mWidth,mHeight,objectToMove = self, facing = "down")
        @collisionArray = collisionArray
        @objectToMove = objectToMove
        @x = @objectToMove.x / 32
        @y = @objectToMove.y / 32
        @delayStart = 950
        @facing = facing
        @animate = true
        @currentMap =  $scene_manager.scene["map"].currentMap.map
        @mWidth = @currentMap.width
        @mHeight = @currentMap.height
        def check_surrounding(direction)
            toLeft = (@x - 1)
            toRight = (@x + 1)
            toTop =  (@y - 1)
            toBottom = (@y + 1)
            case direction
            when "up"
                if @y != 0 
                    return @collisionArray[@x][toTop]
                else
                    return 1
                end
            when "down"
                if @y != @mHeight
                    return @collisionArray[@x][toBottom]
                else
                    return 1
                end
            when "left"
                if @x != 0
                    return @collisionArray[toLeft][@y]
                else
                    return 1
                end
            when "right"
                if @x <= @mWidth
                    return @collisionArray[toRight][@y]
                else
                    return 1
                end
            end
        end
        def willCollide(direction,mWidth,mHeight,surroundingCheck)
            if @x == (mWidth  - 2) && direction ==  "right"
                return true
            elsif @y == 0 && direction == "up"
                return true
            elsif @y == (mHeight - 1) && direction ==  "down"
                return true
            elsif @x == 0 && direction == "left"
                return true
            elsif surroundingCheck == 0
                return false
            elsif surroundingCheck == 1 
                return true
            elsif surroundingCheck == 2
                return true
            elsif surroundingCheck == "player"
                return true
            else
                return false
            end
        end
        def objectCollision(sight,dir,checkX,checkY)
            x = $scene_manager.scene["player"].x or checkX
            y = $scene_manager.scene["player"].y or checkY
            @range = sight
            if @range < (y - @y).abs && (x - @x).abs > @range #Within Total Sight
                case dir
                when "up"
                    if y <= @y
                        return true
                    end
                when "down"
                    if y >= @y
                        return true
                    end
                when "left"
                    if x <= @x
                        return true
                    end
                when "right"
                    if x >= @x
                        return true
                    end
                end
            end
        end
        
        upCheck = check_surrounding("up")
        downCheck = check_surrounding("down")
        leftCheck = check_surrounding("left")
        rightCheck = check_surrounding("right")

        moveUp = ->(distance=1,optional=true){ 
            for a in (1..distance) do
                if optional
                    @facing = "up"
                    if !willCollide("up",@mWidth,@mHeight,upCheck)
                        draw_character(@objectToMove, "up",2)
                        @objectToMove.y = (@objectToMove.y - 32)
                    else
                        @objectToMove.set_animation(12)
                    end
                end
            end
        }
        moveDown = ->(distance=1,optional=true){
            for a in (1..distance) do
                @facing = "down"
                if !willCollide("down",@mWidth,@mHeight,downCheck)
                    draw_character(@objectToMove, "down",2) 
                    @objectToMove.y = (@objectToMove.y + 32)
                else
                    @objectToMove.set_animation(0)
                end
            end
        }
        moveRight = ->(distance=1){
            for a in (1..distance) do
                @facing = "right"
                if !willCollide("right",@mWidth,@mHeight,rightCheck)
                    draw_character(@objectToMove, "right",2) 
                    @objectToMove.x = ( @objectToMove.x + 32)
                else
                    @objectToMove.set_animation(8)
                end
            end
        }
        moveLeft = ->(distance=1){ 
            for a in (1..distance) do
                @facing = "left"
                if !willCollide("left",@mWidth,@mHeight,leftCheck)
                    draw_character(@objectToMove, "left",2)
                    @objectToMove.x = (@objectToMove.x - 32)
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
                        if !willCollide("up",@mWidth,@mHeight,upCheck)
                            moveUp.call(1)
                        else
                            if x <= @x # player to the left
                                if !willCollide("left",@mWidth,@mHeight,leftCheck)
                                    moveLeft.call(1)
                                else
                                    if !willCollide("right",@mWidth,@mHeight,rightCheck)
                                        moveRight.call(1)
                                    end
                                end
                            elsif x > @x #player to the right
                                if !willCollide("right",@mWidth,@mHeight,rightCheck)
                                    moveRight.call(1)
                                else
                                    if !willCollide("left",@mWidth,@mHeight,leftCheck)
                                        moveLeft.call(1)
                                    end
                                end
                            end
                        end
                    else
                        if x > @x
                            if !willCollide("right",@mWidth,@mHeight,rightCheck)
                                moveRight.call(1)
                            else
                                if !willCollide("up",@mWidth,@mHeight,upCheck)
                                    moveUp.call(1)
                                end
                            end
                        else
                            if !willCollide("left",@mWidth,@mHeight,leftCheck)
                                moveLeft.call(1)
                            else
                                if !willCollide("up",@mWidth,@mHeight,upCheck)
                                    moveUp.call(1)
                                end
                            end
                        end
                    end
                end
            when "down"
                if lookingForPlayer(sight,"down")
                    if (y - @y).abs > (x - @x).abs # player X Closer Then Y
                        if !willCollide("down",@mWidth,@mHeight,downCheck)
                            moveDown.call(1)
                        else
                            if x <= @x # player to the left
                                if !willCollide("left",@mWidth,@mHeight,leftCheck)
                                    moveLeft.call(1)
                                else
                                    if !willCollide("right",@mWidth,@mHeight,rightCheck)
                                        moveRight.call(1)
                                    end
                                end
                            elsif x > @x #player to the right
                                if !willCollide("right",@mWidth,@mHeight,rightCheck)
                                    moveRight.call(1)
                                else
                                    if !willCollide("left",@mWidth,@mHeight,leftCheck)
                                        moveLeft.call(1)
                                    end
                                end
                            end
                        end
                    else
                        if x > @x
                            if !willCollide("right",@mWidth,@mHeight,rightCheck)
                                moveRight.call(1)
                            else
                                if !willCollide("down",@mWidth,@mHeight,downCheck)
                                    moveUp.call(1)
                                end
                            end
                        else
                            if !willCollide("left",@mWidth,@mHeight,leftCheck)
                                moveLeft.call(1)
                            else
                                if !willCollide("down",@mWidth,@mHeight,downCheck)
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
                        if !willCollide("left",@mWidth,@mHeight,leftCheck)
                            moveLeft.call(1)
                        elsif willCollide("left",@mWidth,@mHeight,leftCheck)
                            if y > @y # player below
                                if !willCollide("down",@mWidth,@mHeight,downCheck)
                                moveDown.call(1)
                                elsif !willCollide("up",@mWidth,@mHeight,upCheck)
                                moveUp.call(1)
                                end
                            elsif y < @y #player above
                                if !willCollide("up",@mWidth,@mHeight,upCheck)
                                moveUp.call(1)
                                elsif !willCollide("down",@mWidth,@mHeight,downCheck)
                                moveDown.call(1)
                                end
                            end
                        end
                    elsif x>@x && @facing == "right" #player to right
                        if !willCollide("right",@mWidth,@mHeight,rightCheck)
                            moveRight.call(1)
                        elsif willCollide("right",@mWidth,@mHeight,rightCheck)
                            if y > @y # player below
                                if !willCollide("down",@mWidth,@mHeight,downCheck)
                                moveDown.call(1)
                                elsif !willCollide("up",@mWidth,@mHeight,upCheck)
                                moveUp.call(1)
                                end
                            elsif y < @y #player above
                                if !willCollide("up",@mWidth,@mHeight,upCheck)
                                moveUp.call(1)
                                elsif !willCollide("down",@mWidth,@mHeight,downCheck)
                                moveDown.call(1)
                                end
                            end
                        end
                    end
                elsif (x - @x).abs < (y - @y).abs && (y - @y).abs > @range   #Range
                    if y > @y && @facing == "down" #player to below
                        if !willCollide("down",@mWidth,@mHeight,downCheck)
                            moveDown.call(1)
                        elsif willCollide("down",@mWidth,@mHeight,downCheck)
                            if x > @x # player right
                                if !willCollide("right",@mWidth,@mHeight,rightCheck)
                                moveRight.call(1)
                                elsif !willCollide("left",@mWidth,@mHeight,leftCheck)
                                moveLeft.call(1)
                                end
                            else #player left
                                if !willCollide("left",@mWidth,@mHeight,leftCheck)
                                moveLeft.call(1)
                                elsif !willCollide("right",@mWidth,@mHeight,rightCheck)
                                moveRight.call(1)
                                end
                            end
                        end
                    elsif y < @y && @facing == "up" #player to above
                        if !willCollide("up",@mWidth,@mHeight,upCheck)
                            moveUp.call(1)
                        elsif willCollide("up",@mWidth,@mHeight,upCheck)
                            if x > @x # player right
                                if !willCollide("right",@mWidth,@mHeight,rightCheck)
                                moveRight.call(1)
                                elsif !willCollide("left",@mWidth,@mHeight,leftCheck)
                                moveLeft.call(1)
                                end
                            else #player left
                                if !willCollide("left",@mWidth,@mHeight,leftCheck)
                                moveLeft.call(1)
                                elsif !willCollide("right",@mWidth,@mHeight,rightCheck)
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
