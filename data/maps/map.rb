class Mapper 
    attr_accessor :width, :height, :events, :collision, :theMap, :mapTiles
    def initialize(tileset,width,height,file) #(t_w, t_h, t_x_count, t_y_count, scr_w = 800, scr_h = 600, isometric = false, limit_cam = true)
        @mapTiles = tileset
        #@collision = Array.new(width){Array.new(height,0)}
        @events = []
        @width = width
        @height = height
        @theMap = Map.new(32, 32, width, height, 800, 600, false, true)
        @mapfile = file
        @player = $scene_manager.scene["player"]
        draw_tile_loop()
        
    end

    def draw_tile_loop()
      mapArrayY = @mapfile['draw']
      @theMapRecord = Gosu.record(@width*32,@height*32) do |x, y|
        if @mapfile != nil
          mapArrayY.each_with_index {|mapArrayX, yIndex|
            mapArrayX.each_with_index {|tile, xIndex|
            #if tile != nil
              @mapTiles.draw_tile(tile[0],yIndex,xIndex,0) #change to draw layers
            #end
            }
          }
        end
      end
    end

    def update()
      @player = $scene_manager.scene["player"]
      #@collision[@player.x][@player.y] = "player"
    end

    def draw()
      @theMapRecord.draw(0,0,0)
    end
end