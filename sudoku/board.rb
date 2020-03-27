require_relative "tile"
require_relative "player"

class Board

    attr_accessor :board, :answer_key, :player

    def self.from_file
        file = File.read("puzzles/sudoku1.txt").split("\n")
        unsolved = file.map { | row | row.split("").map { | num | Tile.new(num.to_i) } }
        
        file2 = File.read("puzzles/sudoku1_solved.txt").split("\n")
        answers = file2.map { | row | row.split("").map(&:to_i) }
        
        [unsolved, answers]
    end

    def initialize()
        @board, @answer_key = Board.from_file
        @player = Player.new("Karen")
    end

    def update_tile(row, col, num)
        @board[row - 1][col - 1].value = num
    end

    def solved?
        @board.each_with_index do | row, row_idx | 
            row.each_with_index do | tile, col_idx | 
                return false if tile.value != @answer_key[row_idx][col_idx]
            end
        end
        puts "You have solved the sudoku board! Congratulations!"
        true
    end

    def render
        puts
        puts "  | 1   2   3   4   5   6   7   8   9"
        puts "- - - - - - - - - - - - - - - - - - -"
        @board.each_with_index do | row, idx |
            row_str = "#{idx + 1} | "
            row.each_with_index do | tile, idx |
                if [2, 5].include?(idx)
                    row_str += "#{tile.value} | "
                else
                    row_str += "#{tile.value}   "
                end
            end
            puts row_str.strip
            puts "- - - - - - - - - - - - - - - - - - -" if [2, 5].include?(idx)
        end
        puts
    end

    def play
        while(1)
            self.render
            row, col, guess = @player.get_move
            self.update_tile(row, col, guess)
            return if solved?
        end
    end

end

if __FILE__ == $PROGRAM_NAME
    b = Board.new()
    b.play
end