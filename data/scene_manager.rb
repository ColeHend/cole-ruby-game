require_relative "files/input.rb"
require_relative "files/game_object.rb"
class SceneManager
    attr_accessor :scene, :currentScene, :feature, :images, :event, :eventMap, :object, :songs, :sounds, :windowskin
    attr_reader :input
    def initialize()    
        @scene = Hash.new
        @feature = Hash.new
        @event = Hash.new
        @eventMap = Array.new(20){Array.new()}
        @object = Hash.new
        @images = Hash.new()
        @input = Input.new()
        @songs = Hash.new
        @sounds = Hash.new
        @windowskin = "fancyWindowSkin"
    end
    def register(sceneName,sceneObject)
        @scene[sceneName] = sceneObject
    end

    def register_image(name,imgName,columns,rows)
        @images[name] = Game_Object.new(name,0,0,0,0,imgName,nil,columns,rows)
           
    end
    def register_song(name,id,ext='.ogg')
        @songs[name] = Res.song(id,true,ext)
    end
    def register_sound(name,id,ext='.ogg')
        @sounds[name] = Res.sound(id,true,ext)
    end
    def register_object(name,img,x,y,bbWidth,bbHeight,cols,rows,img_gap=nil)
        @object[name]= GameObject.new(x,y,bbWidth,bbHeight,img,img_gap,cols,rows)
    end

    def registerFeature(featureName,featureClass)
        @feature[featureName] = featureClass
    end

    def registerEvent(mapNumber=1,eventName,entireEvent)
        @event[eventName] = entireEvent
        @eventMap[mapNumber].push(entireEvent)
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
        #@input.update
    end

    def draw()
       
            @currentScene.draw()
            time = 0
    end
end