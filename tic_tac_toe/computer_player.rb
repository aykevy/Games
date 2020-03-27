class ComputerPlayer

    attr_reader :mark

    def initialize(mark)
        @mark = mark
    end

    def get_position(legal_positions)
        move = legal_positions.sample
        puts "Computer with mark '" + @mark.to_s + "' chose " + move[0].to_s + " " + move[1].to_s
        move
    end
end