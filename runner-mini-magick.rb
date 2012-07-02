#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__

require 'setup/requires'

print "mini_magick, jpeg image: "
Procedure.run :mini_magick, image("samples/peacock.jpg")

print "mini_magick, png image: "
Procedure.run :mini_magick, image("samples/peacock.png")
