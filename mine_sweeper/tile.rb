class Tile

    attr_reader :tile_state, :has_bomb, :adjacents, :count
    
    def initialize
        @tile_state = "" #bombed / flagged / revealed
        @has_bomb = false
        @adjacents = []
        @count = 0
    end

    def set_bomb(bomb)
        @has_bomb = bomb
    end

    def set_state(state)
        @tile_state = state
    end

    def neighbors(adjacents)
        @adjacents = adjacents
    end

    def neighbors_bomb_count(board)
        total = 0
        @adjacents.each do | coordinate |
            row, col = coordinate
            if board[row][col].has_bomb == true
                total += 1
            end
        end
        @count = total
    end
end
