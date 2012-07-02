#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__

require 'setup/requires'

print "ruby-vips, jpeg image: "
Procedure.run :vips, image("samples/peacock.jpg")

print "ruby-vips, png image: "
Procedure.run :vips, image("samples/peacock.png")
