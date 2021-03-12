require_relative "../../files/animate.rb"
require_relative "../move_collision.rb"
class Event
  attr_accessor :animate, :canMove, :moving, :collidable, :x,:y,:dir, :type, :distance
  include MoveCollision, Animate
  def initialize(sprite, x, y, eventTrigger, collidable, event)
    @x = x
    @y = y
    @z = 5
    @dir = 8
    @sprite = sprite
    @eventTrigger = eventTrigger
    @solid = collidable
    @moveType = "facePlayer"
    @distance = 4

    if @solid
      @collidable = 1
    else
      @collidable = 0
    end

    @event = event
    @moving = false
    @animate, @canMove, @time, @frame = false, false, 100, 4

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
  def update(playerX, playerY, actionKeyTriggered,collisionArray)
    update_stuff(@x,@y,@dir,@animate,@canMove,@moving)
    collisionArray[@x][@y] = @collidable
    
    move_event(collisionArray,@moveType,@distance,40,30)
   

    case @eventTrigger
    when EventTrigger::AUTOMATIC
      if isInTriggerSpot(playerX, playerY)
        @event.call
      end
    when EventTrigger::ACTION_KEY 
      if actionKeyTriggered && isInTriggerSpot(playerX, playerY)
        @event.call
      end
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
    draw_character(@sprite,@dir,@x,@y,@z,@animate,@canMove,@time,@frame,@moving)
  end
end