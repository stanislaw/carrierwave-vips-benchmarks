#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__

require 'setup/requires'

best_of = 3
best_of = ARGV[1].to_i if ARGV[1]

print "rmagick, jpeg image: "
Procedure.run :rmagick, image("samples/peacock.jpg"), best_of

print "rmagick, png image: "
Procedure.run :rmagick, image("samples/peacock.png"), best_of
