require_relative "../files/animate.rb"
module MoveCollision
    def move_event(collisionArray,moveType,force,mWidth,mHeight,objectToMove = self,forceVar)
        @collisionArray = collisionArray
        @forces = forceVar
        @objectToMove = objectToMove
        @x = @objectToMove.x / 32
        @y = @objectToMove.y / 32
        @delayStart = 950
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

        moveUp = ->(force){ 
            if !willCollide("up",40,30,upCheck)
                draw_character(@objectToMove, "up",2)
                @objectToMove.y = (@objectToMove.y - 32)
            else
                @objectToMove.set_animation(12)
            end
        }
        moveDown = ->(force){
            if !willCollide("down",40,30,downCheck)
                draw_character(@objectToMove, "down",2) 
                @objectToMove.y = (@objectToMove.y + 32)
            else
                @objectToMove.set_animation(0)
            end
        }
        moveRight = ->(force){
            if !willCollide("right",40,30,rightCheck)
                draw_character(@objectToMove, "right",2) 
                @objectToMove.x = ( @objectToMove.x + 32)
            else
                @objectToMove.set_animation(8)
            end
        }
        moveLeft = ->(force){ 
            if !willCollide("left",40,30,leftCheck)
                draw_character(@objectToMove, "left",2)
                @objectToMove.x = (@objectToMove.x - 32)
            else
                @objectToMove.set_animation(4)
            end
        }
        
        moveRandom = ->(){
            
            @delayStop = Gosu.milliseconds
            puts("delayStop v")
            puts(@delayStop)
            if (@delayStop - @delayStart < 1000)

                puts("RANDOM EVENT MOVE TRIGGERED") 
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
        followPlayer = ->(sight=2,betweenMove=250){
            @delayStop = Gosu.milliseconds
            if (@delayStop - @delayStart < betweenMove)
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
        end
         }
        case moveType
        when "none"
            @animate = false 
        when "up"
            moveUp.call(force)
        when "down"
            moveDown.call(force)
        when "left"
            moveLeft.call(force)
        when "right" 
            moveRight.call(force)
        when "random"
            
            @delayStart = Gosu.milliseconds
            if (Gosu.milliseconds / 175 % 16 == 0)
                puts(@delayStart)
                moveRandom.call()
            end
        when "facePlayer"
            @animate = false
            facePlayer.call(force)
        when "followPlayer"
            @delayStart = Gosu.milliseconds
            followPlayer.call(force)
        else
            @animate = false 
        end
    end
end
