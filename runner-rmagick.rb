#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__

require 'setup/requires'

print "rmagick, jpeg image: "
Procedure.run :rmagick, image("samples/peacock.jpg")

print "rmagick, png image: "
Procedure.run :rmagick, image("samples/peacock.png")
