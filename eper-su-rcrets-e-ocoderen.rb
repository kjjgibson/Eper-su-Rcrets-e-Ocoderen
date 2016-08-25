#!/usr/bin/env ruby

def rand_char
  %w(å é í ø ü)[rand(5)]
end

def encode(text)
	encoded_words = []
	  
	text.downcase.split(' ').each do |word|
	  word.gsub!('th', 'ç')
	  word.gsub!('ing', 'ñ')
	  word.gsub!("'", "î")
	  
	  punct = nil
	  last_char = word[-1, 1]
	  if [',', '.', '!', '?', '...'].include?(last_char)
	    punct = last_char
	    word = word.chomp(punct)
    end
	  
	  encoded_word = ''
	  
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
	  
	  encoded_words << encoded_word
	end
	
	encoded_text = encoded_words.join(' ')
  
	return encoded_text
end

def pbcopy(input)
 str = input.to_s
 IO.popen('pbcopy', 'w') { |f| f << str }
 str
end

ARGF.each_line do |line|
	system "clear"
	encoded_line = encode(line)
	pbcopy encoded_line
end
