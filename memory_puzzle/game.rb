require_relative "board"
require_relative "human_player"
require_relative "ai_player"

class Game

    attr_accessor :board

    def initialize(*players)
        @players = players
        @current_player = @players[0]
        @board = Board.new()
        @board.populate
    end

    def switch_turn
        c_index = @players.index(@current_player)
        @current_player = @players[(c_index + 1) % @players.length]
    end

    def show(guess)
        2.times do
            @board.flip(*guess)
            system("clear")
            @board.render
            sleep(1)
        end
    end

    def prompt
        puts "Please enter a coordinate to choose the first card"
        first_guess = @current_player.get_input(@board.grid)
        show(first_guess)

        puts "Please enter a coordinate to choose the second card"
        second_guess = @current_player.get_input(@board.grid)
        show(second_guess)

        [first_guess, second_guess]
    end

    def winner_found?
        return false unless @board.won?
        puts "#{@current_player.name}' is the winner revealing the last card!"
        true
    end

    def play
        while(1)
            puts "#{@current_player.name}'s turn!"
            first_guess, second_guess = self.prompt
            if @board[*first_guess] == @board[*second_guess]
                @board.flip(*first_guess)
                @board.flip(*second_guess)

                puts
                puts "=========RESULT=========="
                @board.render
                puts "You got a match!"
                puts
                return if self.winner_found?
                
            else
                puts
                puts "=========RESULT=========="
                @board.render
                puts "Sorry not a match!"
                puts
                self.switch_turn
            end
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    player1 = AIPlayer.new("Chase")
    player2 = AIPlayer.new("Pablo")
    game = Game.new(player1, player2)
    game.play
end