class HumanPlayer

    attr_reader :mark

    def initialize(mark)
        @mark = mark
    end

    def get_position(legal_positions)
        puts "Enter a position as follows:row# col#"
        while true
            response = gets.chomp
            pos = response.split(" ")
            move = pos.map { | ele | ele.to_i }
            if legal_positions.include?(move)
                return move
            else
                puts "Not a legal or valid move, try again"
            end
        end
    end
end