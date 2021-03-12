class Map 
    attr_accessor :width, :height, :events, :collision
    def initialize(tileset,width,height,file)
        @tileset = Gosu::Image.load_tiles(tileset, 32, 32, tileable: true)
        @collision = Array.new(width){Array.new(height,0)}
        @events = []
        @width = width
        @height = height
        @mapfile = file
        @player = $scene_manager.scene["player"]
    end

    def set_collide(x,y,collideNum)
      @collision[x][y] = collideNum
    end
    
    def write(tile,xPos,yPos,z,collision)
        @collision[xPos][yPos] = collision
        @tileset[tile].draw(xPos*32,yPos*32,z)
    end
    def drawLoop(tile,startX,startY,endX,endY,z,collision)
        for a in (startX ... endX)
          for b in (startY ... endY)
          write(tile,a,b,z,collision)
          end
        end
      end
    
      def loopDraw()
        drawNum = 0
        if @mapfile != nil
          while drawNum< @mapfile['drawLoop'].length
            tile = @mapfile['drawLoop'][drawNum]['tile']
            startX = @mapfile['drawLoop'][drawNum]['startX']
            startY = @mapfile['drawLoop'][drawNum]['startY']
            endX = @mapfile['drawLoop'][drawNum]['endX']
            endY = @mapfile['drawLoop'][drawNum]['endY']
            z = @mapfile['drawLoop'][drawNum]['z']
            collidable = @mapfile['drawLoop'][drawNum]['collidable']
            drawLoop(tile,startX,startY,endX,endY,z,collidable)
            drawNum += 1
          end
        end
    end
    
      def update()
        
      end
      def draw(events)
        @player = $scene_manager.scene["player"]
        @event = events
        loopDraw()
        @event.each{|e|@collision[e.x][e.y] = e.collidable}
        @collision[@player.x][@player.y] = 1
      end
end