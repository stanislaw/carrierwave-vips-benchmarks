#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__

require 'setup/requires'

best_of = 3
best_of = ARGV[1].to_i if ARGV[1]

print "mini_magick, jpeg image: "
Procedure.run :mini_magick, image("samples/peacock.jpg"), best_of

print "mini_magick, png image: "
Procedure.run :mini_magick, image("samples/peacock.png"), best_of
