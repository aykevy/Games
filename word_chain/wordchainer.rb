class WordChainer

    attr_accessor :dictionary, :current_words, :all_seen_words
    def initialize(dictionary_file_name)
        @dictionary = []
        File.open(dictionary_file_name) do | filePath |
            filePath.each { | line | @dictionary << line.chomp }
        end
    end

    def adjacent_word(word)
        og_length = word.length
        og_parts = word.split("")

        same_length_words = @dictionary.select { | other_word | other_word.length == og_length }

        same_length_words.select do | word |
            count = 0
            word.split("").each_with_index { | char, idx| count += 1 if char == og_parts[idx] }
            count == og_length - 1
        end
    end

    def words_origin(new_current_words)
        puts
        new_current_words.each do | word |
            puts "#{word} came from #{@all_seen_words[word]}"
        end
        puts
    end

    def explore_current_words
        new_current_words = []
        @current_words.each do | word |
            adjacent = self.adjacent_word(word)
            adjacent.each do | adj_word |
                unless @all_seen_words.keys.include?(adj_word)
                    new_current_words << adj_word
                    @all_seen_words[adj_word] = word
                end
            end
        end
        self.words_origin(new_current_words)
        new_current_words
    end

    def build_path(target)
        path = [target]
        starting = target
        while true
            if @all_seen_words[starting] != nil
                previous = @all_seen_words[starting]
                path << previous
                starting = previous
            else
                break
            end
        end
        return "Final Path: #{path.reverse}"
    end

    def run(source, target)
        @current_words = [source]
        @all_seen_words = {source => nil}
        
        while @current_words.length != 0
            new_current_words = self.explore_current_words
            @current_words = new_current_words
            break if @all_seen_words.keys.include?(target)
        end
        self.build_path(target)
    end

end

stuff = WordChainer.new("dictionary.txt")
puts stuff.run("bake", "glop")