class Card

    attr_accessor :face, :face_value

    def initialize(value)
        @face_value = value
        @face = "?"
    end

    def hide
        @face = "?"
    end

    def reveal
        @face = @face_value
    end

    def ==(other_card)
        self.face_value == other_card.face_value
    end

end