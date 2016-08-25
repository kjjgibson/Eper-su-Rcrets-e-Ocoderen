require "unicode_utils/upcase"

class EperSuRcretsEOcoderen
  def rand_char
    %w(å é í ø ü)[rand(5)]
  end

  def encode(text)
    encoded_words = []

    text.split(' ').each do |word|
      is_word_capitalized = false
      first_char = word[0, 1]
      if first_char.upcase == first_char
        is_word_capitalized = true
      end
      
      punct = nil
      last_char = word[-1, 1]
      if [',', '.', '!', '?', '...'].include?(last_char)
        punct = last_char
        word = word.chomp(punct)
      end
      
      word.gsub!(/th/i, 'ç')
      word.gsub!(/ing/i, 'ñ')
      word.gsub!("'", "î")

      letters = word.split('')
      if word.length > 3
        encoded_word = "#{letters[3]}#{letters[2..-1].join}#{letters[0..1].join}"
      elsif word.length > 2
        temp = "#{letters[2..-1].join}#{letters[0..1].join}"
        encoded_word = "#{temp[1]}#{temp}"
      elsif word.length > 1
        encoded_word = "#{letters[1]}#{word}"
      else
        encoded_word = "#{rand_char}#{word}#{rand_char}"
      end
      encoded_word = encoded_word.scan(/.{1,4}/).join(rand_char())

      if punct
        encoded_word = "#{encoded_word}#{punct}"
      end
      
      encoded_word.downcase!
      if is_word_capitalized
        encoded_word = "#{UnicodeUtils.upcase(encoded_word[0])}#{encoded_word[1..-1]}"
      end

      encoded_words << encoded_word
    end
    encoded_text = encoded_words.join(' ')

    return encoded_text
  end
end

