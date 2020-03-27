require_relative "player"
require_relative "ai"

class Game

    attr_accessor :players_list, :fragment, :dictionary, :current_player, :previous_player, :record

    def initialize(*players)
        @players_list = players
        @fragment = ""
        @record = Hash.new(0)
        @dictionary = Hash.new()
        File.open("dictionary.txt") do | filePath |
            filePath.each { | line | @dictionary[line.chomp] = true }
        end

        @current_player, @previous_player = @players_list[0], @players_list[-1]
    end

    def next_player!
        c_index = @players_list.index(@current_player)
        @previous_player = @current_player
        @current_player = @players_list[(c_index + 1) % @players_list.length]
    end

    def valid_play?(frag)
        alphabet = ("a".."z").to_a
        return false if frag.split("").any? { | letter | !alphabet.include?(letter) }
        @dictionary.each { | k, v| return true if k.start_with?(frag) }
        false
    end

    def valid_word?(frag)
        @dictionary.each { | k, v| return true if k == frag }
        false
    end

    def check_winner 
        if @players_list.length == 1
            puts "#{@current_player.name}: is the winner for being the last one standing!"
            puts
            return true
        end
        false
    end

    def remove_players
        @record.each do | player, score |
            if score == 5 && @players_list.include?(player)
                remove_idx = @players_list.index(player)
                @players_list.delete_at(remove_idx)
            end
        end
    end

    def increase_score
        @record[@current_player] += 1
    end

    def display_board
        ghost_score = ["", "G", "GH", "GHO", "GHOS", "GHOST"]
        puts "=====Players Left======="
        @players_list.each { | player | puts "#{player.name}" }
        puts "========================"
        puts
        puts "=========Board=========="
        @record.each { | k, v | puts "#{k.name}: #{ghost_score[v]}" }
        puts "========================"
        puts
        puts "========Fragment========"
        puts @fragment
        puts "========================"
        puts
    end

    def game_intro
        puts "------------------------------------------------"
        puts "Ghost game with: "
        @players_list.each { | player | puts "#{player.name}"}
        puts "------------------------------------------------"
        puts
    end

    def play_round
        while (1)

            valid_letter = false
            
            while valid_letter == false
                if @current_player.is_a?(AI)
                    guess = @current_player.guess(@fragment, @dictionary)
                else
                    guess = @current_player.guess
                end

                if valid_play?(@fragment + guess) == true
                    valid_letter = true
                else
                    puts "Invalid play, please continue guessing."
                end
            end

            puts "#{@current_player.name} has decided to choose #{guess}"
            puts

            if valid_word?(@fragment + guess)
                puts "Round Lost!"
                puts
                @fragment = ""
                self.increase_score
                self.next_player!
                self.remove_players
                self.display_board
                return if check_winner == true

            else
                @fragment += guess
                self.next_player!
                self.display_board
            end

        end
    end
end

if __FILE__ == $PROGRAM_NAME
    p1 = Player.new("Sandiego")
    p2 = Player.new("Kevin")
    p3 = AI.new("Kary")
    game = Game.new(p1, p2, p3)
    game.play_round
end