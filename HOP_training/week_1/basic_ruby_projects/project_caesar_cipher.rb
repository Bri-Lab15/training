def caesar_cipher(text, shift)
  result = ""

  # Iterate through each character in the input string
  text.each_char do |char|
    # Check if the character is an alphabetic letter
    if char =~ /[A-Za-z]/
      # Determine whether it's uppercase or lowercase
      # and choose the correct ASCII starting point
      start = (char =~ /[A-Z]/) ? 'A'.ord : 'a'.ord

      # Shift the character with wrap-around using modulo 26
      shifted = (char.ord - start + shift) % 26 + start

      # Convert back to a character and append to result
      result << shifted.chr
    else
      # Non-alphabetic characters (e.g., spaces, punctuation)
      # remain unchanged
      result << char
    end
  end

  # Return the final encrypted string
  result
end


# Example usage:
puts caesar_cipher("What a string!", 5) # "Bmfy f xwnsl!"
