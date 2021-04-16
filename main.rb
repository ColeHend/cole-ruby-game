require 'minigl'
include MiniGL
Dir[File.join(__dir__, 'data', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'files', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'maps', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'maps','characters', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'maps','characters','magic', '*.rb')].each { |file| require file }
class MyGame < GameWindow
  def initialize
    super 800, 600, false
    $window = self
    
    $scene_manager = SceneManager.new
    $scene_manager.register("title",TitleScreen.new())
    $scene_manager.register("gameover",Gameover.new())
    $scene_manager.registerFeature("party",PlayerParty.new)
    $scene_manager.feature["party"].addToParty(PlayerCharacter.new("Steve",10))  
    $scene_manager.register_object("fancyWindowSkin","fancyWindowSkin",0,0,0,0,6,4)
    $scene_manager.register_object("earthboundWindowSkin","earthboundWindowSkin",0,0,0,0,6,4)
    $scene_manager.register_object("blackWindowSkin","blackWindowSkin",0,0,0,0,6,4)
    $scene_manager.register_image("CastleTownTileset","CastleTown",8,23)
    $scene_manager.images["windowSkin"] = $scene_manager.object["fancyWindowSkin"]
    
    #$scene_manager.register("player",Player.new())
    $scene_manager.switch_scene("title") 
  end

  def update
    $time = Gosu::milliseconds()
    self.caption = "Game FPS = " +(Gosu.fps()).to_s
    KB.update
    
    $scene_manager.update
  end

  def draw
    $scene_manager.draw
  end
end

game = MyGame.new
game.show