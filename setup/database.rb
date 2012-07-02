require 'active_record'
require 'kernel'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

capture_stdout do
  ActiveRecord::Schema.define do
    create_table :users, :force => true do |t|
      t.integer :name

      t.string :rmagick_avatar
      t.string :mini_magick_avatar
      t.string :image_science_avatar
      t.string :vips_avatar
    end
  end
end
