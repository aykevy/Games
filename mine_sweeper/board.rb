require_relative "tile"

class Board

    attr_accessor :board, :game_over

    def self.create_board
        bombs = [true, false, false, false, false, false, false, false, false, false].shuffle
        board = Array.new(9) { Array.new(9) { Tile.new() } }
        board.each do | row |
            row.each do | tile | 
                tile.set_bomb(bombs.sample)
            end
        end
    end

    def initialize
        @board = Board.create_board
        @game_over = false
        @bomb_count = 0
        @non_bomb_count = 0
    end

    def set_numbers
        @board.each_with_index do | sub_arr, row_idx |
            sub_arr.each_with_index do | tile, col_idx |
                adjacents = self.get_adjacents(row_idx, col_idx)
                tile.neighbors(adjacents)
                tile.neighbors_bomb_count(@board)
            end
        end
    end

    def get_adjacents(row_idx, col_idx)
        adjacents = [
            [row_idx - 1, col_idx - 1], [row_idx - 1, col_idx], [row_idx - 1, col_idx + 1],
            [row_idx, col_idx - 1], [row_idx, col_idx + 1],
            [row_idx + 1, col_idx - 1], [row_idx + 1, col_idx], [row_idx + 1, col_idx + 1]
        ]
        adjacents.select do | coordinates |
            row, col = coordinates
            row >= 0 && row <= 8 && col >= 0 && col <= 8
        end
    end

    def render_hidden
        puts "Answer Key:"
        @board.each do | row |
            row_picture = ""
            row.each do | tile |
                if tile.has_bomb == true
                    row_picture += "b"
                elsif tile.count != 0
                    row_picture += "#{tile.count}"
                else
                    row_picture += "."
                end
                row_picture += " "
            end
            puts row_picture
        end
        puts
    end

    def show_board
        puts "Board:"
        @board.each do | row |
            row_picture = ""
            row.each do | tile |
                if tile.tile_state == "revealed"
                    if tile.count == 0
                        row_picture += "."
                    else
                        row_picture += "#{tile.count}"
                    end
                elsif tile.tile_state == "flagged"
                    row_picture += "f"
                elsif tile.tile_state == "bombed"
                    row_picture += "b"
                else
                    row_picture += "?"
                end
                row_picture += " "
            end
            puts row_picture
        end
        puts
    end

    def count_bombs
        num_tiles = 0
        bombs = 0
        @board.each do | sub_arr |
            sub_arr.each do | tile | 
                bombs += 1 if tile.has_bomb == true
                num_tiles += 1
            end
        end
        @bomb_count = bombs
        @non_bomb_count = num_tiles - bombs
    end

    def trigger_bombs
        @board.each do | sub_arr |
            sub_arr.each do | tile |
                if tile.has_bomb == true
                    tile.set_state("bombed")
                end
            end
        end
    end

    def check_adjacents_have_no_bomb(tile)
        adj = tile.adjacents.all? do | coords |
            row, col = coords
            @board[row][col].has_bomb == false
        end
    end

    def check_for_reveals(seen, todo, todo_tile)
        if self.check_adjacents_have_no_bomb(todo_tile) == true
            return todo_tile.adjacents.select do | coords |
                !seen.include?(coords) && !todo.include?(coords)
            end
        else
            return []
        end
    end

    def mass_reveal(tile) 
        seen = []
        todo = []
        tile.set_state("revealed") unless tile.tile_state == "flagged"
        todo = tile.adjacents if self.check_adjacents_have_no_bomb(tile) == true
        while todo.length > 0
            tile_coord = todo.pop
            seen << tile_coord
            row, col = tile_coord
            todo_tile = @board[row][col]
            todo_tile.set_state("revealed") unless todo_tile.tile_state == "flagged"
            todo += self.check_for_reveals(seen, todo, todo_tile)
        end
    end

    def is_flag?(tile)
        tile.tile_state == "flagged"
    end

    def win?
        revealed = 0
        @board.each do | sub_arr |
            sub_arr.each do | tile | 
                revealed += 1 if tile.tile_state == "revealed" && tile.has_bomb == false
            end
        end
        @revealed_count = revealed
        revealed == @non_bomb_count
    end

    def end_game
        @game_over = true
    end

    def show_stats
        puts @bomb_count
        puts @non_bomb_count
        puts @revealed_count
    end

    def tap(coord)
        tile = @board[coord[0]][coord[1]]
        unless self.is_flag?(tile)
            unless tile.has_bomb == true
                self.mass_reveal(tile)
                if self.win? == true
                    self.end_game
                    puts "You Won!"
                end
            else
                self.trigger_bombs
                self.end_game
                puts "You Lost!"
            end
        else
            puts "That is flagged."
        end
        puts
    end

    def flag(coord)
        tile = @board[coord[0]][coord[1]]
        if tile.tile_state != "revealed" && tile.tile_state != "bombed"
            tile.set_state("flagged")
        else
            puts "That is already revealed."
        end
    end

    def unflag(coord)
        tile = @board[coord[0]][coord[1]]
        if self.is_flag?(tile)
            tile.set_state("")
        else
            puts "That is not a flag."
        end
    end

    def ask_action
        while true
            puts "Please enter a action and coordinate:"
            puts "================================================="
            puts "f for flag    Ex: f,0,0 means flagging at 0,0"
            puts "c for check   Ex: c,4,4 means checking at 4,4"
            puts "u for unflag  Ex: u,0,0 means unflagging at 0,0"
            puts "n,n for coordinate (must be after action)"
            puts "================================================="
            the_guess = gets.chomp.split(",")
            puts
            if the_guess.length == 3
                return [the_guess[0], the_guess[1].to_i, the_guess[2].to_i]
            else
                puts "Invalid entry."
            end
        end
    end

    def play
        self.set_numbers
        self.count_bombs
        while @game_over == false
            self.render_hidden
            self.show_board
            coords = self.ask_action
            if coords.first == "f"
                self.flag(coords[1..-1])
            elsif coords.first == "u"
                self.unflag(coords[1..-1])
            elsif coords.first == "c"
                self.tap(coords[1..-1])
            end
        end
        self.show_board
    end
end

b = Board.new
b.play