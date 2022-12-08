require_relative "input_trigger.rb"
class Input
    attr_reader :input, :inputStack
    def initialize() #push() to end of array. pop remove last value
        @pressed = 0
        @inputStack = Array.new
    end
    def addToStack(endOfLine)
        @inputStack.push(endOfLine)
        #puts("pushed! "+endOfLine)
    end
    def removeFromStack(nameToRemove)
        stackLength = ($scene_manager.input.inputStack.length-1)
        for a in (0..stackLength) do
            if @inputStack[a] == nameToRemove
                @inputStack.pop
                #puts("popped! "+nameToRemove)
            end
        end
        
    end
    def checkStack(nameToCheck)
        stackLength = ($scene_manager.input.inputStack.length-1)
        for a in (0..stackLength) do
            if @inputStack[a] == nameToCheck
                return true
            else
                return false
            end
        end
        
    end

    def inputRun()
        length = @inputStack.length
        @inputStack[(length-1)]
    end

    def keyHeld(key)
        if $window.button_down?(key)
            return true
        end
    end
    def keyPressed(key)
        if KB.key_pressed?(key)
            return true
        end
    end
    def keyReleased(key)
        if KB.key_released?(key)
            return true
        end
    end
    def keyDown(id,stackName="map")
        if $scene_manager.input.inputStack[$scene_manager.input.inputStack.length-1] == stackName
            case id
            when InputTrigger::UP
                keyHeld(InputTrigger::UP)
            when InputTrigger::DOWN
                keyHeld(InputTrigger::DOWN)
            when InputTrigger::LEFT
                keyHeld(InputTrigger::LEFT)
            when InputTrigger::RIGHT
                keyHeld(InputTrigger::RIGHT)
            when InputTrigger::SELECT
                keyPressed(InputTrigger::SELECT)
            when InputTrigger::ESCAPE
                keyPressed(InputTrigger::ESCAPE)
            end
        end
    end
    def keyDown2(id)
        stackLength = ($scene_manager.input.inputStack.length-1)
        if $scene_manager.input.inputStack[stackLength] == "map"
            case id
            when InputTrigger::UP
                keyHeld(InputTrigger::UP)
            when InputTrigger::DOWN
                keyHeld(InputTrigger::DOWN)
            when InputTrigger::LEFT
                keyHeld(InputTrigger::LEFT)
            when InputTrigger::RIGHT
                keyHeld(InputTrigger::RIGHT)
            when InputTrigger::SELECT
                keyPressed(InputTrigger::SELECT)
            when InputTrigger::ESCAPE
                keyPressed(InputTrigger::ESCAPE)
            end
            
        end
    end
    def eventMove(moveType,vector,object)
        moveType = "none"
        case moveType
        when "none"
        when "up"
            moveUp.call(distance)
        when "down"
            moveDown.call(distance)
        when "left"
            moveLeft.call(distance)
        when "right" 
            moveRight.call(distance)
        else 
        end
    end
    def eventPath(type)
        case type
            when "random"
                @delayStart = Gosu.milliseconds
                if (Gosu.milliseconds / 175 % 16 == 0)
                    moveRandom.call(@randomNum)
                end
            when "facePlayer"
                @animate = false
                facePlayer.call(distance)
            when "followPlayer"
                @delayStart = Gosu.milliseconds
                followPlayer.call(distance)
            when "faceFollowPlayer"
                @delayStart = Gosu.milliseconds
                faceFollowPlayer.call()
        end
    end
    def update
    end
end
