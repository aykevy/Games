class AI

    attr_reader :name, :alphabet

    def initialize(name)
        @name = name
        @alphabet = ("a".."z").to_a
    end

    def valid_play?(word, dict)
        return false if word.split("").any? { | letter | !@alphabet.include?(letter) }
        dict.each { | k, v| return true if k.start_with?(word) }
        false
    end

    def valid_word?(word, dict)
        dict.each { | k, v| return true if k == word }
        false
    end

    def guess(current_word, dictionary)
        valid_letter = []
        valid_lose = []
        @alphabet.each do | letter |
            combine = current_word + letter
            if self.valid_play?(combine, dictionary) && !self.valid_word?(combine, dictionary)
                valid_letter << letter
            elsif self.valid_play?(combine, dictionary) && self.valid_word?(combine, dictionary)
                valid_lose << letter
            end
        end
        
        if !valid_letter.empty?
            return valid_letter.sample
        else
            return valid_lose[0]
        end
    end
end