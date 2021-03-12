class Option
    attr_reader :text, :function, :text_image
    def initialize(text, function)
        @text = text
        @function = function
        @text_image = Gosu::Image.from_text(text, 20)
    end
end
