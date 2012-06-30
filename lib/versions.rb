#!/usr/bin/ruby

require 'rubygems'

require 'RMagick'
require 'image_science'
require 'vips'

include Magick

LIBVIPS_VERSION = %x[vips --version]

puts
system %[uname -a]

puts
puts "\nVersions:\n"

puts
puts Magick::Long_version
puts

puts "Image Science #{ImageScience::VERSION}"
puts

puts "Ruby-vips #{VIPS::VERSION} built against #{LIBVIPS_VERSION}"
puts
