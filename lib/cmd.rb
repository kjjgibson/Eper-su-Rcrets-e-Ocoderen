#!/usr/bin/env ruby
require 'clipboard'
require_relative 'eper-su-rcrets-e-ocoderen'
require 'getoptlong'

opts = GetoptLong.new(
    ['--seed', '-s', GetoptLong::OPTIONAL_ARGUMENT]
)

seed = nil
opts.each do |opt, arg|
  case opt
    when '--seed'
      seed = arg.to_i
  end
end

encoder = EperSuRcretsEOcoderen.new(seed)

ARGF.each_line do |line|
  system 'clear'
  encoded_line = encoder.encode(line)
  Clipboard.copy(encoded_line)
end

s