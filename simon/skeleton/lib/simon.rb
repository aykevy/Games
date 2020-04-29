class Simon
  COLORS = %w(red blue green yellow)

  attr_accessor :sequence_length, :game_over, :seq

  def initialize
    @sequence_length = 1
    @game_over = false
    @seq = Array.new

  end

  def play
    until @game_over
      take_turn
    end
    puts game_over_message
    reset_game
  end

  def take_turn
    if @game_over == false
      @sequence_length += 1
      puts round_success_message
    end
    show_sequence
    user_answer = require_sequence
    print "#{@seq}  or  #{user_answer} "
    if @seq != user_answer
      @game_over = true
    end
  end

  def show_sequence
    add_random_color
    puts @seq
  end

  def require_sequence
    puts "Please give sequence: "
    seq = gets.chomp.split(",")
    seq
  end

  def add_random_color
    seq << COLORS.sample
  end

  def round_success_message
    :round_success_message
  end

  def game_over_message
    :game_over_message
  end

  def reset_game
    @sequence_length = 1
    @game_over = false
    @seq = Array.new
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Simon.new
  game.play
end

