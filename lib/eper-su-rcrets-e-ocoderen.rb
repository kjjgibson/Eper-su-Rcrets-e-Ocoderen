require 'unicode_utils/upcase'
require 'faker'

class EperSuRcretsEOcoderen

  attr_accessor :seed, :fake_freq

  module CharacterSets
    IGNORED_CHARS = %w(å é í ø ü)
    FAKE_WORD_MARKERS = %w(æ œ ß)
  end

  def rand_char(char_set)
    char_set[rand(char_set.length)]
  end

  def seed=(value)
    if value
      srand(value)
    end
  end

  def initialize(s, ff)
    self.seed = s
    self.fake_freq = ff
      puts "Initializing seed to #{Random::DEFAULT.seed}"
  end

  def encode(text)
    encoded_words = []
    text.split(' ').each_with_index do |word, word_index|
      encoded_word = word

      # If the word contains no alpha chars then don't do anything with it as it's likely to be a number or an emoji
      if word.match(/[a-z]/i) != nil
        is_word_capitalized = false
        first_char = word[0, 1]
        if first_char.upcase == first_char
          is_word_capitalized = true
        end

        punct = nil
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
          encoded_word = "#{rand_char(CharacterSets::IGNORED_CHARS)}#{word}#{rand_char(CharacterSets::IGNORED_CHARS)}"
        end
        encoded_word = encoded_word.scan(/.{1,4}/).join(rand_char(CharacterSets::IGNORED_CHARS))

        if end_punct
          encoded_word = "#{encoded_word}#{end_punct}"
        end

        encoded_word.downcase!
        if is_word_capitalized
          encoded_word = "#{UnicodeUtils.upcase(encoded_word[0])}#{encoded_word[1..-1]}"
        end
      end

      # Print a random word, every n words, but don't print it if it's first word
      # 0 % 4 == 0 is true, we don't want this, as it would add a random word at
      # the start of every sentence
      if word_index % self.fake_freq == 0 && word_index != 0
        fake_word = Faker::Space.moon
        # This is so our recursion doesn't go bananas, we only want one level of recursion.
        if fake_word.split.size == 1
          encoded_fake_word = encode(fake_word)
          encoded_marked_fake_word = encoded_fake_word.insert(rand(fake_word.length), rand_char(CharacterSets::FAKE_WORD_MARKERS))
          encoded_words << encoded_marked_fake_word
        end
      end

      encoded_words << encoded_word
    end
    encoded_text = encoded_words.join(' ')

    return encoded_text
  end
end
