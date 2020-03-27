require_relative "card"

class Board

    attr_accessor :grid

    def initialize
        @grid = Array.new(2) { Array.new(2) }
    end

    def render #Works
        puts "==========BOARD=========="
        @grid.each do | row |
            row_format = ""
            row.each { | card | row_format += card.face + " " }
            puts row_format.strip
        end
        puts "========================="
    end

    def populate
        alphabet = ("a".."z").to_a
        all_moves = [[0, 0], [0, 1], [0, 2], [0, 3], [1, 0], [1, 1], [1, 2], [1,3]]
        4.times do
            letter = alphabet.sample
            2.times do
                position = all_moves.sample
                p position
                row, col = position
                @grid[row][col] = Card.new(letter)
                all_moves.delete(position)
            end
            alphabet.delete(letter)
        end
    end

    def flip(row_num, col_num)
        card = @grid[row_num][col_num]
        if card.face == "?"
            card.reveal
        else
            card.hide
        end
    end

    def won?
        @grid.each do | row |
            row.each { | card | return false if card.face == "?" }
        end
        true
    end

    def [](col, row)
        @grid[col][row]
    end

end