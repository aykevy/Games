class Board
  attr_accessor :cups, :name1, :name2

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14) { Array.new() }
    self.place_stones
  end

  def place_stones
    @cups.each_with_index do | c, idx |
      unless idx == 6 || idx == 13
        4.times { c << :stone }
      end
    end
  end

  def valid_move?(start_pos)
    if start_pos < 0 || start_pos > 13
      raise "Invalid starting cup"
    elsif @cups[start_pos].empty?
      raise "Starting cup is empty"
    end
  end

  def place_pieces(start_pos, current_player_name)
    opponent_cup = current_player_name == @name1 ? 13 : 6
    count = @cups[start_pos].length
    @cups[start_pos] = []

    start_index = start_pos + 1
    while true
      break if count == 0
      c_index = start_index % 14
      unless c_index == opponent_cup
        @cups[c_index] << :stone
        count -= 1
      end
      start_index += 1 unless count == 0
    end

    start_index
  end

  def make_move(start_pos, current_player_name)
    ending_index = self.place_pieces(start_pos, current_player_name)
    self.render
    to_switch = self.next_turn(ending_index)
    if to_switch.nil?
      real_index = ending_index % 14
      if real_index == 6 && current_player_name == @name1
        return :prompt
      elsif real_index == 13 && current_player_name == @name2
        return :prompt
      else
        return real_index
      end
    end
    to_switch
  end

  def next_turn(ending_cup_idx)
    return :switch if @cups[ending_cup_idx].nil?
    nil
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    side1 = (0..5).all? { | idx | @cups[idx].empty? }
    side2 = (7..12).all? { | idx2 | @cups[idx2].empty? }
    side1 || side2
  end

  def winner
    p1_points = cups[6].length
    p2_points = cups[13].length
    return :draw if p1_points == p2_points
    p1_points > p2_points ? @name1 : @name2
  end
end