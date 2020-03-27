class HumanPlayer

    attr_reader :name

    def initialize(name)
        @name = name
    end

    def get_input(board)
        while (1)
            guess = gets.chomp.split
            if guess.length == 2 && guess.all? { | num | num.to_i.to_s == num }
                row, col = guess[0].to_i, guess[1].to_i
                return [row, col]
            else
                puts "Invalid input, try again."
            end
        end
    end

end