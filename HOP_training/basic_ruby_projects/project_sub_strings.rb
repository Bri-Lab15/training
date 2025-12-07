def substrings(text, dictionary)
  # Result hash with default value 0 for easy counting
  result = Hash.new(0)

  # Split text into words and normalize to lowercase
  words = text.downcase.split

  # Check each dictionary entry against each word
  dictionary.each do |entry|
    entry_down = entry.downcase

    words.each do |word|
      # If the word contains the dictionary entry, count it
      if word.include?(entry_down)
        result[entry] += 1
      end
    end
  end

  result
end

# Example usage:
dictionary = [ "below", "down", "go", "going", "horn", "how", "howdy", "it", "i", "low", "own", "part", "partner", "sit" ]
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
