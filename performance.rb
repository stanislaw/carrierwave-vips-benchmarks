$:.unshift File.dirname __FILE__

require 'require_all'
require 'cutter'

require 'active_record'

require 'carrierwave'
require 'carrierwave/orm/activerecord'


require_all File.expand_path('../lib', __FILE__)
require_all File.expand_path('../app', __FILE__)

# Print out what version we're running
puts "Active Record #{ActiveRecord::VERSION::STRING}"

# Connect to an in-memory sqlite3 database (more on this in a moment)
ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.integer :name

    t.string :magick_avatar
    t.string :vips_avatar
  end
end

image = File.open('samples/peacock.jpg')

puts image.inspect

10.times do
  u = User.new :name => 'first'
  u.magick_avatar = image
  u.save!
end

10.times do
  u = User.new :name => 'first'
  u.vips_avatar = image
  u.save!
end
