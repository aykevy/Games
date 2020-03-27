class Board

    attr_reader :size

    def self.print_grid(arr)
        arr.each do | row |
            str_format = row.join(" ")
            puts str_format
        end
    end

    def initialize(n)
        @grid = Array.new(n) { Array.new(n, :N) }
        @size = n * n
    end

    def [](arr)
        @grid[arr[0]][arr[1]]
    end

    def []=(pos, value)
        @grid[pos[0]][pos[1]] = value
    end

    def num_ships
        @grid.flatten.count(:S)
    end

    def attack(pos)
        
        if self[pos] == :S
            self[pos]= :H
            puts "you sunk my battleship!"
            return true
        else
            self[pos] = :X
            return false
        end
    end

    def place_random_ships
        n = 0
        row_col_size = Math.sqrt(size)
        percentage = (size * 0.25).to_i
        while n < percentage
            randRow = rand(row_col_size)
            randCol = rand(row_col_size)
            if self[[randRow, randCol]] != :S
                self[[randRow, randCol]] = :S
                n += 1
            end
        end

    end

    def hidden_ships_grid
        @grid.map do | subArr |
            result = subArr.map do | ele |
                if ele == :S
                    :N
                else
                    ele
                end
            end
        end
    end

    def cheat
        Board.print_grid(@grid)
    end

    def print
        Board.print_grid(self.hidden_ships_grid)
    end




  
    
end