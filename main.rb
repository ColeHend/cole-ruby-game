require 'minigl'
include MiniGL
Dir[File.join(__dir__, 'data', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'files', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'maps', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'maps','characters', '*.rb')].each { |file| require file }
class MyGame < GameWindow
  def initialize
    super 800, 600, false 
  end

  def update
    # game logic here
  end

  def draw
    # drawing logic here
  end
end

game = MyGame.new
game.show