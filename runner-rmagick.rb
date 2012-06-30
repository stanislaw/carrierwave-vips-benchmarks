#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__
$:.unshift File.expand_path 'lib', File.dirname(__FILE__)

require 'setup/requires'

image = File.open('samples/peacock.jpg')

puts
puts image.inspect

n = 200

stamper :rmagick do
  NUMBER.times do
    u = User.new :name => 'first'
    u.rmagick_avatar = image
    u.save!
  end
end
