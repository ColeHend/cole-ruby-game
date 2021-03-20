class HPbar
    def initialize(x,y,maxHP,nowHP)
        @x, @y, @maxHP, @nowHP = x, y, maxHP, nowHP
        @visible = true
    end
    def set_visibility(visible)
        @visible = visible
    end

    def update(x,y,maxHP,nowHP)
        @x, @y, @maxHP, @nowHP = x, y, maxHP, nowHP
    end

    def draw
        if (@nowHP/@maxHP) < 1
            Gosu.draw_rect(@x, @y, 32, 4, Gosu::Color.argb(0xff_310202), 6) #Dark Red Max HP
            Gosu.draw_rect(@x, @y, (32*(@nowHP/@maxHP)), 4, Gosu::Color.argb(0xff_e71e1e), 7) #lighter Red Max HP
        end
    end
end