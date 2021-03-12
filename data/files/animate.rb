module Animate  # @sprite[@dir].draw(@x*32,@y*32,@z)
    attr_accessor :direction, :x, :y, :z, :animate,:canMove, :moving
        
        @multiplier = 1

    def update_stuff(x,y,dir,animate,canMove,moving)
        @dir, @x, @y, @animate, @canMove,@moving = dir, x, y, animate, canMove, moving
    end

    def draw_character(img,direction,x,y,z,animate,canMove,time,frame,moving)
        @img, @dir, @x, @y, @z, @animate, @canMove,@moving = img, direction, x, y, z, animate, canMove,moving
        @time = 175
        @frame = 4 
        @img[@dir].draw((@x*32),(@y*32),@z)
        if @animate == true
            if @canMove
                case @dir
                when (12..15)
                   
                    if (Gosu.milliseconds / @time % @frame == 0)
                        if @dir == 15
                            @dir = 12
                        else
                            @dir += 1
                        end
                        @img[@dir].draw((@x*32),(@y*32),@z)
                    end
                    
                when (0..3)
                    if (Gosu.milliseconds / @time % @frame == 0)
                        if @dir == 3
                            @dir = 0
                        else
                            @dir += 1
                        end
                        @img[@dir].draw((@x*32),(@y*32),@z)
                    end
                    
                when (4..7)
                   if (Gosu.milliseconds / @time % @frame == 0)
                        if @dir == 7
                            @dir = 4
                        else
                            @dir += 1
                        end
                        @img[@dir].draw((@x*32),(@y*32),@z)
                   end
                       
                when (8..11)
                    if (Gosu.milliseconds / @time % @frame == 0)
                        if @dir == 11
                            @dir = 8
                        else
                            @dir += 1
                        end 
                        @img[@dir].draw((@x*32),(@y*32),@z)
                    end
                    
                end
             end
        elsif @animate == false
            
            case @dir
            when (12..15) #up
                @dir = 12
            when (0..3) #down
                @dir = 0
            when (4..7) #left
                @dir = 4
            when (8..11) #right
                @dir = 8
            end
            @img[@dir].draw((@x*32),(@y*32),@z)
        else
            
        end
     end
   
end