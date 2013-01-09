#!/usr/bin/env ruby

require 'rubygems'

require 'RMagick'
require 'vips'

# include Magick

system %[uname -a]

puts
puts Magick::Long_version
puts

puts "MiniMagick 3.4"
puts

puts "Ruby-vips #{VIPS::VERSION} built against libvips #{VIPS::LIB_VERSION}"
puts

