class Player

    attr_accessor :name

    def initialize(name)
        @name = name
    end

    def get_move
        while (1)
            puts "Type a row and column number followed by a guess"
            guess = gets.chomp.split
            if guess.length == 3 && guess.all? { | num | num.to_i.to_s == num }
                row, col, num = guess.map(&:to_i)
                return [row, col, num]
            else
                puts "Invalid input, try again."
            end
        end
    end
end