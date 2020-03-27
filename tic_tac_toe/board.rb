class Board
    
    attr_reader :grid

    def initialize(n)
        @grid = Array.new(n) { Array.new(n, "_") }
    end

    def valid?(pos)
        return false if pos.any? { | num | num > @grid[0].length - 1 }
        @grid[pos[0]][pos[1]] == "_"
    end

    def place_mark(pos, mark)
        if self.valid?(pos)
            @grid[pos[0]][pos[1]] = mark
        else
            raise "Not valid position or marked previously."
        end
    end

    def print_board
        @grid.each_with_index do | subArr, subidx |
            subArr.each_with_index do | ele, idx|
                if idx != subArr.length - 1
                    print ele + " | "
                else
                    print ele
                end
            end
            puts
            puts 
        end
        puts
    end

    def win_row?(mark)
        @grid.any? { | subArr | subArr.length == subArr.count(mark) }
    end

    def win_col?(mark)
        count = Hash.new(0)
        @grid.each do | subArr |
            subArr.each_with_index do | ele, idx |
                count[idx] += 1 if ele == mark
            end
        end
        count.has_value?(@grid[0].length)
    end

    def check_diagonal(arr, mark)
        count = 0
        (0..arr.length - 1).each do | idx |
            count += 1 if arr[idx][idx] == mark
        end
        count == arr.length
    end

    def win_diagonal?(mark)
        check_diagonal(@grid, mark) || check_diagonal(@grid.reverse, mark)
    end

    def empty_positions?
        @grid.each { | subArr | subArr.each { | ele | return true if ele == "_" } } 
        false
    end

    def legal_positions
        legal_list = []
        @grid.each_with_index do | subArr, idx1|
            subArr.each_with_index do | ele, idx2 |
                legal_list << [idx1, idx2] if ele == "_"
            end
        end
        legal_list
    end
end