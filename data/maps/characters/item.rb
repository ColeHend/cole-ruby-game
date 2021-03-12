class Item
    attr_reader :name, :function
    attr_accessor :used
    def initialize(name,function)
        @name, @function,@used = name, function,false
    end
end