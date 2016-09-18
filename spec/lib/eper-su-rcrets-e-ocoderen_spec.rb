require 'eper-su-rcrets-e-ocoderen'
require 'support/eper_shared_examples'
describe 'encoding' do
  let(:seed) { 1 }
  let(:fake_word_frequency) { 3 }
  let(:encoder) { EperSuRcretsEOcoderen.new(seed, fake_word_frequency) }
  describe 'a whole sentence' do

    context 'a large sentence' do
      let(:phrase) { "This is a test sentence :), I'm checking that things don't regress LOL WTF BBQ" }
      let(:outcome) { 'Çsçi sis åaé œbsbsén tsttåe tnteüncesüe :), yçysæíte Imiî ceckíñch çtça sßssiéerme çsçñ înîtådo rgreéssre tæptuénene Lllo Wfwt Bqbb' }
      it_behaves_like 'word encoder'
    end

    context 'inject fake words' do
      let(:fake_word_markers) { %w(æ œ ß) }
      context 'a line of text with 4 words' do
        let(:phrase) { 'ab ab ab ab ab ab' }
        it 'adds a fake word in after every 3 words' do
          encoded_phrase = encoder.encode(phrase)
          encoded_words_array = encoded_phrase.split
          expect(encoded_words_array.length).to eq(7)

          # We know what encoded words should look like
          # so test that the injected word is not the
          # expected word
          first_injected_fake_word = encoded_words_array[3]
          second_injected_fake_word = encoded_words_array[7]
          expect(first_injected_fake_word).to_not eq('bab')
          expect(second_injected_fake_word).to_not eq('bab')

          found_fake_word = fake_word_markers.any? { |char| first_injected_fake_word.include?(char) }
          expect(found_fake_word).to be_truthy
        end
      end
    end

  end
  describe 'a word' do
    context '1 character' do
      let(:phrase) { 'i' }
      let(:outcome) { 'øiü' }
      it_behaves_like 'word encoder'
    end

    context '2 characters' do
      let(:phrase) { 'at' }
      let(:outcome) { 'tat' }
      it_behaves_like 'word encoder'
    end

    context '3 characters' do
      let(:phrase) { 'two' }
      let(:outcome) { 'totw' }
      it_behaves_like 'word encoder'
    end

    context 'with capitals' do
      let(:phrase) { 'Testing' }
      # The first letter in the new encoded word must be capitalized
      let(:outcome) { 'Tstñøte' }
      it_behaves_like 'word encoder'
    end

    context 'with punctuation' do
      let(:phrase) { 'Testing!' }
      let(:outcome) { 'Tstñøte!' }
      it_behaves_like 'word encoder'
    end

  end

  describe 'replacements' do
    context 'for "ing"' do
      let(:phrase) { 'testing' }
      let(:outcome) { 'tstñøte' }
      it_behaves_like 'word encoder'
    end

    context 'for "th"' do
      let(:phrase) { 'theodore' }
      let(:outcome) { 'dodoøreçe' }
      it_behaves_like 'word encoder'
    end

    context 'for apostrophes' do
      let(:phrase) { "it's" }
      let(:outcome) { 'sîsiøt' }
      it_behaves_like 'word encoder'
    end
  end


end

