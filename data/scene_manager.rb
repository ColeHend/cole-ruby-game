require_relative "files/input.rb"
class SceneManager
    attr_accessor :scene, :currentScene, :feature, :images, :events, :eventMap
    attr_reader :input
    def initialize()    
        @scene = Hash.new
        @feature = Hash.new
        @events = Hash.new
        @eventMap = Array.new(20){Array.new()}
        @images = Hash.new()
        @input = Input.new()
    end
    def register(sceneName,sceneObject)
        @scene[sceneName] = sceneObject
    end

    def register_image(name,imgLocation,tileWidth,tileHeight)
        @images[name] = Gosu::Image.load_tiles(imgLocation, tileWidth, tileHeight)   
    end

    def registerFeature(featureName,featureClass)
        @feature[featureName] = featureClass
    end

    def registerEvent(mapNumber=1,eventName,event)
        @events[eventName] = event
        @eventMap[mapNumber].push(event)
    end

    def switch_scene(sceneName)
        @currentScene = @scene[sceneName]
    end

    def get_scene(scene)
        return @scene[scene]
    end

    def scene_method(sceneName,method)
        @scene[sceneName].method
        
    end

    def update()
        @currentScene.update() 
        @input.update
    end

    def draw()
       
            @currentScene.draw()
            time = 0
    end
end