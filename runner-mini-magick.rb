#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__
$:.unshift File.expand_path 'lib', File.dirname(__FILE__)

require 'setup/requires'

stamper :mini_magick do
  NUMBER.times do
    u = User.new :name => 'first'
    u.mini_magick_avatar = image
    u.save!
  end
end
