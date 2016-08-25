#!/usr/bin/env ruby
require 'clipboard'
require 'eper-su-rcrets-e-ocoderen'

ARGF.each_line do |line|
  system 'clear'
  encoded_line = encode(line)
  Clipboard.copy(encoded_line)
end