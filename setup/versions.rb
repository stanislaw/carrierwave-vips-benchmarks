#!/usr/bin/ruby

require 'rubygems'

require 'RMagick'
require 'image_science'
require 'vips'

include Magick

LIBVIPS_VERSION = %x[vips --version]

system %[uname -a]

puts
puts Magick::Long_version
puts

puts "MiniMagick 3.4"
puts

puts "Image Science #{ImageScience::VERSION}"
puts

puts "Ruby-vips #{VIPS::VERSION} built against #{LIBVIPS_VERSION}"
puts

