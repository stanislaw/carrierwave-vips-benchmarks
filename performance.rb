require 'require_all'
require 'active_record'

require_all File.expand_path('../app', __FILE__)

# Print out what version we're running
puts "Active Record #{ActiveRecord::VERSION::STRING}"

# Connect to an in-memory sqlite3 database (more on this in a moment)
ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

# Create the minimal database schema necessary to reproduce the bug
ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.integer :name

    t.string :magick_avatar
    t.string :vips_avatar
  end
end
