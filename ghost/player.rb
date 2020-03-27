class Player

    attr_reader :name

    def initialize(name)
        @name = name
    end

    def guess()
        alphabet = ("a".."z").to_a
        correct = false
        while correct == false
            puts "#{name}, please enter a character:"
            the_guess = gets.chomp.downcase.split("")
            puts
            if the_guess.length == 1 && alphabet.include?(the_guess[0])
                correct = true
                return the_guess[0]
            else
                puts "Invalid character"
            end
        end
    end

end