require 'json'
class SaveGame
    def initialize()
        @player = $scene_manager.scene["player"]
        @playerSave = {"player"=>[@player.x,@player.y]}
        @saveEvents = $scene_manager.event.map {|key,value|
                     {key=> [value.x,value.y]}
        }
        @party = $scene_manager.feature["party"]
        @saveEvents.push(@playerSave)
        @totalSave = @saveEvents.reduce(:merge)
        puts("---------------------------------")
        puts(@totalSave['Event101'][0])
        writeSave(1)
        loadSave(1)
        puts("---------------------------------")
    end

    def writeSave(saveNum)
        file = File.open("Saves/Save#{saveNum}.json", 'w')
        file.write(@totalSave.to_json) 
    end
    def loadSave(saveNum)
        savefile = File.read("Saves/Save#{saveNum}.json")
        puts(savefile)
        files = JSON.load(savefile)
        puts(files)
        puts("loaded^")
    end

    def update
    end
    def draw
    end

end