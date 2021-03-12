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
            if $scene_manager.input.inputStack[a] == nameToRemove
                @inputStack.pop
                #puts("popped! "+nameToRemove)
            end
        end
        
    end
    def inputRun()
        length = @inputStack.length
        @inputStack[(length-1)]
    end
    
    def keyPressed(key)
        if $window.button_down?(key) then
            return true
        end
    end

    def keyDown(id)
        if keyPressed(id)
                case id
                when InputTrigger::UP 
                    puts(@inputStack)
                    return true
                when InputTrigger::DOWN 
                    puts("down")
                    return true
                when InputTrigger::LEFT
                    puts("left")
                    return true
                when InputTrigger::RIGHT 
                    puts("right")
                    return true
                when InputTrigger::SELECT 
                    puts("select")
                    
                    if @pressed == 0
                        @pressed = 2
                        return true
                    end
                when InputTrigger::ESCAPE 
                    puts("escape")
                    if @pressed == 0
                        @pressed = 2
                        return true
                    end
                else 
                    return false
                end
            end
        

    end
    def update
        if @pressed >= 1 then @pressed = @pressed - 1 end
    end
    def keyUp(id)
    end
end