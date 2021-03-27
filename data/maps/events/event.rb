require_relative "../../files/animate.rb"
require_relative "move_collision.rb"
require_relative "movement_control.rb"
require_relative "hpbar.rb"
class Event
  attr_accessor :animate, :canMove, :moving, :collidable, :x, :y, :w, :h, :dir, :moveType, :distance, :stats, :activateType, :vector
  include MoveCollision, Animate, Control_movement
  def initialize(object, eventTrigger, collidable, event,stats)
    @x = object.x 
    @y = object.y
    @w = object.w
    @h = object.h
    @vector = Vector2.new(0, 0)
    @z = 5
    @dir = 8
    @stats = stats
    @eventObject = object
    @eventTrigger = eventTrigger
    @solid = collidable
    @moveType = "followPlayer"
    @activateType = "SELECT" # SELECT or TOUCH options
    @distance = 1
    @hpbar = HPbar.new(@x,@y,10,10)
    
    @event = event
    @moving = false
    @animate, @canMove, @facing = false, true, "down"

  end

  def set_move(kind,dist=6*32)
    canMove()
    @moveType = kind
    @distance = dist
    case @moveType
      when "random"
        randomDir = rand(4)
        startTime = Gosu.milliseconds
        RandomMove(@vector,@eventObject,randomDir,startTime)
      when "followPlayer"
        Follow(@vector, @eventObject,dist)
    end
  end

  def activate_event
    @event.call
  end

  def update(playerX, playerY, actionKeyTriggered)
    @player = $scene_manager.scene["player"]
    update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
    @hpbar.update(@x,@y,10,10)
    set_move(@moveType)
  end

  def draw()
    @eventObject.draw()
    @hpbar.draw
    #draw_character(@sprite,@dir,@x,@y,@z,@animate,@canMove,@time,@frame,@moving)
  end
end
