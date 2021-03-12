module MoveCollision
    def move_event(collisionArray,moveType,distance,mWidth,mHeight)
        @collisionArray = collisionArray
        def check_surrounding(direction)
            toLeft = (@x - 1) 
            toRight = (@x + 1)
            toTop =  (@y - 1)
            toBottom = (@y + 1)
            case direction
            when "up"
               return @collisionArray[@x][toTop]
            when "down"
                return @collisionArray[@x][toBottom]
            when "left"
                return @collisionArray[toLeft][@y]
            when "right"
                return @collisionArray[toRight][@y]
            end
        end
        def willCollide(direction,mWidth,mHeight,surroundingCheck)
            if @x == (mWidth - 2) && direction ==  "right"
                return true
            elsif @y == 0 && direction == "up"
                return true
            elsif @y == (mHeight - 2) && direction ==  "down"
                return true
            elsif @x == 0 && direction == "left"
                return true
            elsif surroundingCheck == 0
                return false
            elsif surroundingCheck == 1
                return true
            else
                return true
            end
        end
        
        upCheck = check_surrounding("up")
        downCheck = check_surrounding("down")
        leftCheck = check_surrounding("left")
        rightCheck = check_surrounding("right")
        moveUp = ->(distance){ @dir = 12
            for a in (1..distance) do
                if (Gosu.milliseconds / 30 % 3 == 0)
                    if !willCollide("up",40,30,upCheck)
                        @animate = true
                        @y = (@y - 1)
                    end
                end
            end
        }
        moveDown = ->(distance){ @dir = 0
            for a in (1..distance) do
                if (Gosu.milliseconds / 30 % 3 == 0)
                    if !willCollide("down",40,30,downCheck)
                        @animate = true
                        @y = (@y + 1)
                    end
                end
            end
        }
        moveRight = ->(distance){ @dir = 8
            for a in (1..distance) do
                if (Gosu.milliseconds / 30 % 3 == 0)
                    if !willCollide("right",40,30,rightCheck)
                        @animate = true
                        @x = (@x + 1)
                    end
                end
            end
        }
        moveLeft = ->(distance){ @dir = 4
            for a in (1..distance) do
                if (Gosu.milliseconds / 30 % 3 == 0)
                    if !willCollide("left",40,30,leftCheck)
                        @animate = true
                        @x = (@x - 1)
                    end
                end
            end
        }
        randomDir = rand(4)
        moveRandom = ->(){
            if (Gosu.milliseconds / 100 % 16 == 0)
                @animate = true
                case randomDir
                when 0
                  @animate = false
                when 1
                    moveRight.call(1)
                when 2
                    moveUp.call(1)
                when 3
                    moveLeft.call(1)
                when 4
                    moveDown.call(1)
                end
            end
        }
        facePlayer = ->(sight=6){
           x = $scene_manager.scene["player"].x
           y = $scene_manager.scene["player"].y
           @range = sight
           if (x - @x).abs <= @range && (y - @y).abs <= @range
            if (y - @y) < 0  && (x - @x) > 0
               if (x-@x).abs < (y-@y).abs
               @dir = 12
               else @dir = 8
               end
            elsif  (y - @y) > 0 && (x - @x) < 0
               if (x-@x).abs < (y-@y).abs
               @dir = 0
               else @dir = 4
               end
            end
           end
        }
        followPlayer = ->(sight=2){
           x = $scene_manager.scene["player"].x
           y = $scene_manager.scene["player"].y
           @range = sight
            if (x - @x).abs > (y - @y).abs && (x - @x).abs > @range
                    if x < @x #player to left
                        if !willCollide("left",40,30,leftCheck)
                            moveLeft.call(1)
                        elsif willCollide("left",40,30,leftCheck)
                            if y > @y # player below
                                if !willCollide("down",40,30,downCheck)
                                moveDown.call(1)
                                elsif !willCollide("up",40,30,upCheck)
                                moveUp.call(1)
                                end
                            elsif y < @y #player above
                                if !willCollide("up",40,30,upCheck)
                                moveUp.call(1)
                                elsif !willCollide("down",40,30,downCheck)
                                moveDown.call(1)
                                end
                            end
                        end
                    elsif x>@x #player to right
                        if !willCollide("right",40,30,rightCheck)
                            moveRight.call(1)
                        elsif willCollide("right",40,30,rightCheck)
                            if y > @y # player below
                                if !willCollide("down",40,30,downCheck)
                                moveDown.call(1)
                                elsif !willCollide("up",40,30,upCheck)
                                moveUp.call(1)
                                end
                            elsif y < @y #player above
                                if !willCollide("up",40,30,upCheck)
                                moveUp.call(1)
                                elsif !willCollide("down",40,30,downCheck)
                                moveDown.call(1)
                                end
                            end
                        end
                    end
                elsif (x - @x).abs < (y - @y).abs && (y - @y).abs > @range
                    if y > @y #player to below
                        if !willCollide("down",40,30,downCheck)
                            moveDown.call(1)
                        elsif willCollide("down",40,30,downCheck)
                            if x > @x # player right
                                if !willCollide("right",40,30,rightCheck)
                                moveRight.call(1)
                                elsif !willCollide("left",40,30,leftCheck)
                                moveLeft.call(1)
                                end
                            else #player left
                                if !willCollide("left",40,30,leftCheck)
                                moveLeft.call(1)
                                elsif !willCollide("right",40,30,rightCheck)
                                moveRight.call(1)
                                end
                            end
                        end
                    elsif y < @y #player to above
                        if !willCollide("up",40,30,upCheck)
                            moveUp.call(1)
                        elsif willCollide("up",40,30,upCheck)
                            if x > @x # player right
                                if !willCollide("right",40,30,rightCheck)
                                moveRight.call(1)
                                elsif !willCollide("left",40,30,leftCheck)
                                moveLeft.call(1)
                                end
                            else #player left
                                if !willCollide("left",40,30,leftCheck)
                                moveLeft.call(1)
                                elsif !willCollide("right",40,30,rightCheck)
                                moveRight.call(1)
                                end
                            end
                        end
                    end
                elsif (y - @y).abs <= (@range) && (x - @x).abs <= (@range)
                   # @animate = false
            end
         }
        case moveType
        when "none"
            @animate = false 
        when "up"
            @dir = 12
            moveUp.call(distance)
        when "down"
            @dir = 0
            moveDown.call(distance)
        when "left"
            @dir = 4
            moveLeft.call(distance)
        when "right" 
            @dir = 8
            moveRight.call(distance)
        when "random"
            moveRandom.call()
        when "facePlayer"
            @animate = false
            facePlayer.call(distance)
        when "followPlayer"
            followPlayer.call(distance)
        else
            @animate = false 
        end
    end
end
