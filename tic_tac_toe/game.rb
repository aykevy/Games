require_relative "board"
require_relative "human_player"
require_relative "computer_player"

class Game

    attr_reader :player_list, :board, :current_player

    def initialize(board_size, players_hash)
        #False = Human, True = Computer
        @player_list = players_hash.map do | h, k |
            if k == false
                HumanPlayer.new(h)
            else
                ComputerPlayer.new(h)
            end
        end
        @board = Board.new(board_size)
        @current_player = @player_list[0]
    end

    def switch_turn
        @player_list.each_with_index do | player, idx |
            if @current_player == player
                @current_player = @player_list[(idx + 1) % @player_list.length]
                break
            end
        end
    end

    def play
        while @board.empty_positions?
            @board.print_board
            pos = @current_player.get_position(@board.legal_positions)
            mark = @current_player.mark
            @board.place_mark(pos, mark)

            if @board.win_row?(mark) || @board.win_col?(mark) || @board.win_diagonal?(mark)
                @board.print_board
                puts "Player with mark '" + @current_player.mark.to_s + "' wins!"
                return
            end
            self.switch_turn
            
        end
        @board.print_board
        puts "It's a draw!"
        return
    end
end

g = Game.new(4, "x" => false, "y" => true)
g.play