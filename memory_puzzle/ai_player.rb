require_relative "card"

class AIPlayer

    attr_reader :name

    def initialize(name)
        @name = name
        @all_moves = [[0, 0], [0, 1], [0, 2], [0, 3], [1, 0], [1, 1], [1, 2], [1, 3]]

        @seen_cards = Hash.new { | h, k | h[k] = [] }
        @matches = Hash.new { | h, k | h[k] = [] }

        @first_move = []
        @first_move_done = false
    end

    def see_faced_up_cards(board)
        known_cards = []
        board.each_with_index do | row, idx1 |
            row.each_with_index do | card, idx2 |
                position = [idx1, idx2]
                if card.face != "?"
                    known_cards << position
                    values = @matches[card.face_value]
                    @matches[card.face_value] << position unless values.include?(position)
                end
            end
        end
        known_cards
    end

    def update_seen_cards
        @matches.each do | k, v |
            if @seen_cards[k].length < v.length || v.length == 2
                @seen_cards[k] = []
            end
        end
    end

    def get_random_move(moves_left)
        guess = []
        while guess.empty?
            get_move = moves_left.sample
            guess = get_move if get_move != @first_move
        end
        guess
    end

    def get_smart_move
        @seen_cards.each_key do | key |
            return @seen_cards[key] if @seen_cards[key].length == 2
        end
        return []
    end

    def determine_move(moves_left)
        guess = self.get_random_move(moves_left)
        better_move = self.get_smart_move

        if @first_move_done == false
            guess = better_move[0] unless better_move.empty?
            @first_move = guess
            @first_move_done = true

        else
            guess = better_move[1] if !better_move.empty?
            guess = better_move[0] if guess == @first_move
            @first_move = []
            @first_move_done = false
            
        end

        guess
    end

    def get_input(board)
        known_cards = self.see_faced_up_cards(board)
        self.update_seen_cards
        moves_left = @all_moves.select { | move | !known_cards.include?(move) }
        guess = self.determine_move(moves_left)

        col, row = guess
        letter = board[col][row].face_value
        @seen_cards[letter] << guess unless @seen_cards[letter].include?(guess)

        guess
    end

end