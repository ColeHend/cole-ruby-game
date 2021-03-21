require_relative "../../files/animate.rb"
require_relative "../move_collision.rb"
require_relative "hpbar.rb"
class Event
  attr_accessor :animate, :canMove, :moving, :collidable, :x, :y, :w, :h, :dir, :type, :distance, :stats, :activateType
  include MoveCollision, Animate
  def initialize(object, eventTrigger, collidable, event,stats)
    @x = object.x 
    @y = object.y
    @w = object.w
    @h = object.h
    @z = 5
    @dir = 8
    @stats = stats
    @eventObject = object
    @eventTrigger = eventTrigger
    @solid = collidable
    @moveType = "facePlayer"
    @activateType = "SELECT" # SELECT or TOUCH options
    @distance = 1
    @hpbar = HPbar.new(@x,@y,10,10)
    if @solid
      @collidable = 1
    else
      @collidable = 0
    end

    @event = event
    @moving = false
    @animate, @canMove, @facing = false, true, "down"

  end

  def isAnimated(isAnimated)
    @animate = isAnimated
  end

  def canMove()
    @animate = !@animate
    @canMove = !@canMove
    @moving = !@moving
  end

  def set_move(kind,dist)
    canMove()
    @moveType = kind
    @distance = dist
  end

  def activate_event
    @event.call
  end

  def update(playerX, playerY, actionKeyTriggered)
    @player = $scene_manager.scene["player"]
    update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
    @hpbar.update(@x,@y,10,10)
    if @canMove
      #move_event(@moveType,@distance,@eventObject,@facing)
      #move_event("eventRun",@distance,@player.player)
    end
    #collisionArray[@x][@y] = @collidable
    
    
    case @eventTrigger
    when EventTrigger::AUTOMATIC
      if isInTriggerSpot(playerX, playerY)
        @event.call
      end
    when EventTrigger::ACTION_KEY
    else
      throw "Event trigger not recognized"
    end

  end

  def isInTriggerSpot(playerX, playerY)
    
    if @solid
      toLeft = playerX == @x - 1 && playerY == @y
      toRight = playerX == @x + 1 && playerY == @y
      toTop = playerX == @x && playerY == @y - 1
      toBottom = playerX == @x && playerY == @y + 1

      return toLeft || toRight || toTop || toBottom
    else
      return playerX == @x && playerY == @y
    end
  end

  def draw()
    @eventObject.draw()
    @hpbar.draw
    #draw_character(@sprite,@dir,@x,@y,@z,@animate,@canMove,@time,@frame,@moving)
  end
end