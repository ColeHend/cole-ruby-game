class SaveGame
    def initialize()
        @player = $scene_manager.scene["player"]
        @party = $scene_manager.feature["party"]
        @currentMap =  $scene_manager.scene["map"].currentMap
        @currentMap.events.each {|e|}
    end

    def update
    end
    def draw
    end

end