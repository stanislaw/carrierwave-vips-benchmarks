#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__

require 'setup/requires'

best_of = 3
best_of = ARGV[1].to_i if ARGV[1]

print "image_science, jpeg image: "
Procedure.run :image_science, image("samples/peacock.jpg"), best_of

print "image_science, png image: "
Procedure.run :image_science, image("samples/peacock.png"), best_of
