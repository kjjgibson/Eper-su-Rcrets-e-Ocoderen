#!/usr/bin/env ruby
require 'clipboard'
require_relative 'eper-su-rcrets-e-ocoderen'
require 'getoptlong'

opts = GetoptLong.new(
    ['--seed', '-s', GetoptLong::OPTIONAL_ARGUMENT],
    ['--debug', '-d', GetoptLong::OPTIONAL_ARGUMENT]
)

seed = nil
debug = false
opts.each do |opt, arg|
  case opt
    when '--seed'
      seed = arg.to_i
    when '--debug'
      debug = true
  end
end

encoder = EperSuRcretsEOcoderen.new(seed)

ARGF.each_line do |line|
  system 'clear'
  encoded_line = encoder.encode(line)
  if debug
    if seed != nil
      puts "Seed Value: '#{seed}'"
    end
    puts "Original String: '#{line.strip!}'"
    puts "Encoded String: '#{encoded_line}'"


  end
  Clipboard.copy(encoded_line)
end