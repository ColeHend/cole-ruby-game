class Item
    attr_reader :name
    attr_accessor :used, :function
    def initialize(name,function)
        @name, @function,@used = name, function,false
    end
end