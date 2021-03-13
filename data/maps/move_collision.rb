require_relative "../files/animate.rb"
module MoveCollision
    def move_event(collisionArray,moveType,force,mWidth,mHeight,objectToMove = self,forceVar)
        @collisionArray = collisionArray
        @forces = forceVar
        @objectToMove = objectToMove

        moveUp = ->(force){ 
            @forces.y = (@forces.y - 50)
            draw_character(@objectToMove, "up",5)
        }
        moveDown = ->(force){
            @forces.y = (@forces.y + 50)
            draw_character(@objectToMove, "down",5) 
        }
        moveRight = ->(force){
            @forces.x = ( @forces.x + 50)
            draw_character(@objectToMove, "right",5) 
        }
        moveLeft = ->(force){ 
            @forces.x = (@forces.x - 50)
            draw_character(@objectToMove, "left",5)
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
            moveUp.call(force)
        when "down"
            moveDown.call(force)
        when "left"
            moveLeft.call(force)
        when "right" 
            moveRight.call(force)
        when "random"
            moveRandom.call()
        when "facePlayer"
            @animate = false
            facePlayer.call(force)
        when "followPlayer"
            followPlayer.call(force)
        else
            @animate = false 
        end
    end
end
