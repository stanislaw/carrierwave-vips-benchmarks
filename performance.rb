puts "Removing images left from previous runs\n"

system %[rm -rf uploads/*]

$:.unshift File.dirname __FILE__
$:.unshift File.expand_path 'lib', File.dirname(__FILE__)

require 'require_all'
require 'cutter'

require 'active_record'

require 'carrierwave'
require 'carrierwave/orm/activerecord'

require_all File.expand_path('../lib', __FILE__)
require_all File.expand_path('../app', __FILE__)

puts "\nActive Record #{ActiveRecord::VERSION::STRING}\n"

# Connect to an in-memory sqlite3 database (more on this in a moment)
ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.integer :name

    t.string :rmagick_avatar
    t.string :mini_magick_avatar
    t.string :image_science_avatar
    t.string :vips_avatar
  end
end

image = File.open('samples/peacock.jpg')

puts
puts image.inspect

n = 50
stamper :rmagick do
  n.times do
    u = User.new :name => 'first'
    u.rmagick_avatar = image
    u.save!
  end
end

stamper :mini_magick do
  n.times do
    u = User.new :name => 'first'
    u.mini_magick_avatar = image
    u.save!
  end
end

stamper :image_science do
  n.times do
    u = User.new :name => 'first'
    u.image_science_avatar = image
    u.save!
  end
end

stamper :vips do
  n.times do
    u = User.new :name => 'first'
    u.vips_avatar = image
    u.save!
  end
end
