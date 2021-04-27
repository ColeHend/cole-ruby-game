class Item
    attr_reader :name
    attr_accessor :used, :function,:codeName
    def initialize(name,codeName,function)
        @name, @function,@used = name, function,false
        @codeName = codeName
    end
end