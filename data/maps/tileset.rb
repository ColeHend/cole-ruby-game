class Tileset
    attr_accessor :impassableTiles
    def initialize(imgName="CastleTown",columns=8,rows=23)
        @tilesetName = imgName
        @tilesetIMG = GameObject.new(0,0,0,0,@tilesetName,nil,columns,rows)
        @impassableTiles = Array.new #Block.new(x,y,w,h)
    end
    def addImpass(x,y)
        @impassableTiles.push(Block.new(x,y,32,32))
    end
    def isPassable(tile)
        if @tilesetName == "CastleTown"
            case tile
            when 16#wall tile upper part start
                return false
            when 17
                return false
            when 18#wall tile upper part end
                return false
            when 24#wall tile lower part start
                return false
            when 25
                return false
            when 26#wall tile lower part end
                return false
            when 32#Table top half start
                return false
            when 33
                return false
            when 34#Table top half end
                return false
            when 40#Table bottom half start
                return false
            when 41
                return false
            when 42#Table bottom half end
                return false
            else 
                return true 
            end
        elsif @tilesetName == "CastleTownExterior"
            case tile
            when 32#wall top start
                return false
            when 33
                return false
            when 34
                return false
            when 40#wall bottom start
                return false
            when 41
                return false
            when 42
                return false
            when 48#water top start
                return false
            when 49
                return false
            when 50
                return false
            when 56#water bottom start
                return false
            when 57
                return false
            when 58
                return false
            when 192#red roof top corner start
                return false
            when 193
                return false
            when 194
                return false
            when 200#red roof bottom corner start
                return false
            when 201
                return false
            when 202
                return false
            when 208#red roof top wall start
                return false
            when 209
                return false
            when 210
                return false
            when 216#red roof bottom wall start
                return false
            when 217
                return false
            when 218
                return false
            else 
                return true
            end
        elsif @tilesetName == "mountainTileset"
            case tile
            when 40#clifftop top
                return false
            when 41
                return false
            when 42
                return false
            when 48
                return false
            when 49
                return false
            when 50
                return false
            when 56
                return false
            when 57
                return false
            when 58
                return false
            when 64#cliffbottom
                return false
            when 65
                return false
            when 66
                return false
            when 72
                return false
            when 73
                return false
            when 74
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