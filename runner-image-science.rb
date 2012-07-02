#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__

require 'setup/requires'

print "image_science, jpeg image: "
Procedure.run :image_science, image("samples/peacock.jpg")
