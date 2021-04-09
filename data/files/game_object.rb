class Game_Object
    attr_accessor :name, :x,:y,:w,:h,:myObject
    def initialize(name,x, y, bbWidth, bbHeight, img, img_gap, cols, rows)
        @myObject = GameObject.new(x, y, bbWidth, bbHeight, img, img_gap, cols, rows)
        @name, @x, @y, @w, @h = name, @myObject.x, @myObject.y, @myObject.w, @myObject.h
    end
    def name
        return @name
    end
    
end