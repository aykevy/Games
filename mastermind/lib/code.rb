class Code
  
  POSSIBLE_PEGS = {'R' => :red, 'G' => :green, 'B' => :blue, 'Y' => :yellow}
  
  def self.valid_pegs?(arr)
    arr.all? { | pegs | POSSIBLE_PEGS.keys.include?(pegs.upcase) }
  end

  def self.random(num)
    new_rand = Code.new(Array.new(num, POSSIBLE_PEGS.keys.sample))
  end

  def self.from_string(pegs)
    new_rand = Code.new(pegs.split(""))
  end

  def initialize(arr)
    if !Code.valid_pegs?(arr)
      raise "Invalid Pegs"
    else
      @pegs = arr.map(&:upcase)
    end
  end

  def pegs
    @pegs
  end

  def [](idx)
    @pegs[idx]
  end

  def length
    @pegs.length
  end

  def num_exact_matches(guess)
    matches = 0
    guess.pegs.each_with_index do | peg, idx |
      matches += 1 if self.pegs[idx] == peg
    end
    matches
  end

  def num_near_matches(guess)
    count = 0
    guess.pegs.each_with_index do | peg, idx |
      if self.pegs[idx] != peg && self.pegs.include?(peg)
        count += 1
      end
    end
    count
  end

  def ==(other_code)
    self.pegs.join("") == other_code.pegs.join("")
  end
  
end