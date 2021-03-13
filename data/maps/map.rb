class Mapper 
    attr_accessor :width, :height, :events, :collision, :tileset, :theMap
    def initialize(tileset,width,height,file) #(t_w, t_h, t_x_count, t_y_count, scr_w = 800, scr_h = 600, isometric = false, limit_cam = true)
        @tileset = GameObject.new(0,0,0,0,"CastleTown",nil,8,23)
        @collision = Array.new(width){Array.new(height,0)}
        @events = []
        @width = width
        @height = height
        @theMap = Map.new(32, 32, width, height, 800, 600, false, true)
        @mapfile = file
        @player = $scene_manager.scene["player"]
    end

    def draw_tile(tile,x,y,passable)
      @collision[x][y] = passable
      #@tileset[tile].draw(xPos*32,yPos*32,z)
      @tileset.set_animation(tile)
      @tileset.x = x*32
      @tileset.y = y*32
      @tileset.draw()
    end
    def draw_multi_tile(tile,startX,startY,endX,endY,collision)
      for a in (startX ... endX)
        for b in (startY ... endY)
        draw_tile(tile,a,b,collision)
        end
      end
    end

    def draw_tile_loop()
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
          draw_multi_tile(tile,startX,startY,endX,endY,collidable)
          drawNum += 1
        end
      end
    end

      def update()
        @player = $scene_manager.scene["player"]
      end
      def draw()
        
        draw_tile_loop()
      end
end