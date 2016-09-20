RSpec.shared_examples 'word encoder' do
  it 'returns the correctly encoded word' do
    encoded_phrase = encoder.encode(phrase)
    expect(encoded_phrase).to eq(outcome)
  end
end