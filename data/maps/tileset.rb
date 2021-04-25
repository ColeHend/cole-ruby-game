class Tileset
    attr_accessor :impassableTiles
    def initialize(imgName="CastleTown")
        @tilesetName = imgName
        @tilesetIMG = GameObject.new(0,0,0,0,@tilesetName,nil,8,23)
        @impassableTiles = Array.new #Block.new(x,y,w,h)
    end
    def addImpass(x,y)
        @impassableTiles.push(Block.new(x,y,28,28))
    end
    def isPassable(tile)
        if @tilesetName == "CastleTown"
            case tile
            when 16
                return false
            when 17
                return false
            when 18
                return false
            when 24
                return false
            when 25
                return false
            when 26
                return false
            else 
                return true 
            end
        end
    end
    def draw_tile(tile,y,x,passable)
        #@collision[x][y] = 0
        passable = isPassable(tile)
        @tilesetIMG.set_animation(tile)
        @tilesetIMG.x = x*32
        @tilesetIMG.y = y*32
        @tilesetIMG.draw()
        if passable == false
            addImpass(x*32,y*32)
        end
      end
    def update
    end

    def draw
    end
end