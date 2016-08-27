require "unicode_utils/upcase"

class EperSuRcretsEOcoderen

  def rand_char
    %w(å é í ø ü)[rand(5)]
  end

  def initialize(seed=nil)
    if seed != nil
      srand(seed)
    end
    puts "Initializing seed to #{Random::DEFAULT.seed}"
  end

  def encode(text)
    encoded_words = []

    text.split(' ').each do |word|
      encoded_word = word

      # If the word contains no alpha chars then don't do anything with it as it's likely to be a number or an emoji
      if word.match(/[a-z]/i) != nil
        is_word_capitalized = false
        is_word_acronym = false
        first_char = word[0, 1]
        if word.upcase == word && word.length > 1
          is_word_acronym = true
        elsif first_char.upcase == first_char
          is_word_capitalized = true
        end

        index_of_punct = word.index(/[^a-z]+$/i)
        end_punct = nil
        if index_of_punct
          end_punct = word[index_of_punct..-1]
          word = word[0...index_of_punct]
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

        if end_punct
          encoded_word = "#{encoded_word}#{end_punct}"
        end

        encoded_word.downcase!
        if is_word_acronym
          encoded_word = UnicodeUtils.upcase(encoded_word)
        elsif is_word_capitalized
          encoded_word = "#{UnicodeUtils.upcase(encoded_word[0])}#{encoded_word[1..-1]}"
        end
      end

      encoded_words << encoded_word
    end
    encoded_text = encoded_words.join(' ')

    return encoded_text
  end
end
