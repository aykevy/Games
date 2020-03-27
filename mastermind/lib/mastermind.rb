require_relative "code"

class Mastermind
   def initialize(length)
      @secret_code = Code.random(length)
   end

   def print_matches(other_code)
      puts @secret_code.num_exact_matches(other_code).to_s
      puts @secret_code.num_near_matches(other_code).to_s
   end

   def ask_user_for_guess
      puts "Enter a code"
      user_input = gets.chomp
      created_code = Code.from_string(user_input)
      print_matches(created_code)
      @secret_code == created_code
   end

end
