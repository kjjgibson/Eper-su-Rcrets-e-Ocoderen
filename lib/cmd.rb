#!/usr/bin/env ruby
require 'clipboard'
require_relative 'eper-su-rcrets-e-ocoderen'

ARGF.each_line do |line|
  system 'clear'
  encoded_line = EperSuRcretsEOcoderen.new.encode(line)
  Clipboard.copy(encoded_line)
end