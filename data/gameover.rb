class Gameover
    def initialize()
        @gameover = Gosu::Image.from_text("Gameover", 50)
        @motivationalText = Gosu::Image.from_text("Press Spacebar to try again loser", 35)
        @input = $scene_manager.input
        @white = Gosu::Color.argb(0xff_ffffff)
    end
    def update
        if KB.key_pressed?(InputTrigger::SELECT)
            $scene_manager.input.removeFromStack("map")
            $scene_manager.input.addToStack("optionsBox")
            $scene_manager.switch_scene("title")
        end
    end
    def draw
        @gameover.draw(350, 100, 5,scale_x = 1, scale_y = 1, color = @white)
        @motivationalText.draw(320, 170, 5,scale_x = 1, scale_y = 1, color = @white)
    end
end
