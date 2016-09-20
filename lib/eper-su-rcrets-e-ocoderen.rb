require 'unicode_utils/upcase'
require 'faker'

class EperSuRcretsEOcoderen

  module CharacterSets
    IGNORED_CHARS = %w(å é í ø ü)
    FAKE_WORD_MARKERS = %w(æ œ ß)
  end

  def rand_char(char_set)
    char_set[rand(char_set.length)]
  end

  # Determine if a fake word should be added
  # * +@fake_freq+ must be greater than 0 -  So we can skip the fake word entirely
  # * +word_index+ mod +@fake_freq+ must be zero
  # * +word_index+ must be greater than one so we don't inject one before the first word.
  # +word_index+ the number of words we've seen so far
  def use_fake_word?(word_index)
    return @fake_freq > 0 && word_index % @fake_freq == 0 && word_index != 0
  end

  def new_fake_word
    fake_words = Faker::Space.translate('faker.space').values.flatten.sample
    first_fake_word = fake_words.split[0].downcase
    return first_fake_word
  end

  def initialize(s, ff)
    @seed = s
    if @seed
      srand(@seed)
    end
    @fake_freq = ff
    puts "Initializing seed to #{Random::DEFAULT.seed}"
  end

  def encode(text)
    encoded_words = []
    text.split(' ').each_with_index do |word, word_index|
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
          encoded_word = "#{rand_char(CharacterSets::IGNORED_CHARS)}#{word}#{rand_char(CharacterSets::IGNORED_CHARS)}"
        end
        encoded_word = encoded_word.scan(/.{1,4}/).join(rand_char(CharacterSets::IGNORED_CHARS))

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

      if use_fake_word?(word_index)

        # This is so our recursion doesn't go bananas, we only want one level of recursion
        first_fake_word = new_fake_word()
        encoded_fake_word = encode(first_fake_word)
        encoded_marked_fake_word = encoded_fake_word.insert(rand(first_fake_word.length), rand_char(CharacterSets::FAKE_WORD_MARKERS))
        encoded_words << encoded_marked_fake_word
      end
      encoded_words << encoded_word
    end
    encoded_text = encoded_words.join(' ')

    return encoded_text
  end
end
