#!/usr/bin/env ruby

$:.unshift File.dirname __FILE__
$:.unshift File.expand_path 'lib', File.dirname(__FILE__)

require 'setup/requires'

stamper :image_science do
  NUMBER.times do
    u = User.new :name => 'first'
    u.image_science_avatar = image
    u.save!
  end
end
