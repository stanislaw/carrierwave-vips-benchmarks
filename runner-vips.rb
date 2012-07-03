#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__

require 'setup/requires'

best_of = 3
best_of = ARGV[1].to_i if ARGV[1]

print "ruby-vips, jpeg image: "
Procedure.run :vips, image("samples/peacock.jpg"), best_of

print "ruby-vips, png image: "
Procedure.run :vips, image("samples/peacock.png"), best_of
