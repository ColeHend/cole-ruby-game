require_relative "characters/enemy_bestiary.rb"
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
        draw_tile_loop_abovePlayer()
    end
    def registerEvent(eventName,imgName,eventX,eventY,bbWidth,bbHeight,columns,rows,mapNumber,bestiaryName,activateType,eventTriggered=->(){})
      $scene_manager.register_object(eventName,imgName,eventX,eventY,bbWidth,bbHeight,columns,rows)
      $scene_manager.registerEvent(mapNumber,eventName,Event.new(
              $scene_manager.object[eventName], 
              eventTriggered,
              Bestiary.new.enemy(bestiaryName)))
      $scene_manager.event[eventName].activateType = activateType
    end
    def draw_tile_loop()
      mapArrayY = @mapfile['draw']
      @theMapRecord = Gosu.record(@width*32,@height*32) do |x, y|
        if @mapfile != nil
          mapArrayY.each_with_index {|mapArrayX, yIndex|
            mapArrayX.each_with_index {|tile, xIndex|
              if tile[0] != nil && tile[0] != "nil"
                @mapTiles.draw_tile(tile[0],yIndex,xIndex,0)
              end
              if tile[1] != nil && tile[1] != "nil"
                @mapTiles.draw_tile(tile[1],yIndex,xIndex,0)
              end
              if tile[2] != nil && tile[2] != "nil"
                @mapTiles.draw_tile(tile[2],yIndex,xIndex,0)
              end
            }
          }
        end
      end
    end
    def draw_tile_loop_abovePlayer()
      mapArrayY = @mapfile['draw']
      @theMapRecordTop = Gosu.record(@width*32,@height*32) do |x, y|
        if @mapfile != nil
          mapArrayY.each_with_index {|mapArrayX, yIndex|
            mapArrayX.each_with_index {|tile, xIndex|
              if tile[3] != nil && tile[3] != "nil"
                @mapTiles.draw_tile(tile[3],yIndex,xIndex,0)
              end
              if tile[4] != nil && tile[4] != "nil"
                @mapTiles.draw_tile(tile[4],yIndex,xIndex,0)
              end
            }
          }
        end
      end
    end
    def waitTimer(cooldownTime,waitTime)
      if ((Gosu::milliseconds - cooldownTime)) >= waitTime
        cooldownTime = Gosu::milliseconds
        return True
        #@meleeCool = false
      end
    end
    def update()
      @player = $scene_manager.scene["player"]
      #@collision[@player.x][@player.y] = "player"
    end

    def draw()
      @theMapRecord.draw(0,0,0)
    end
    def drawAbove
      @theMapRecordTop.draw(0,0,0)
    end
end