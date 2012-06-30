require 'cutter'

Cutter::Stamper.scope :rmagick => "RMagick" do |rmagick|
end

Cutter::Stamper.scope :mini_magick => "mini_magick" do |rmagick|
end

Cutter::Stamper.scope :image_science => "Image Science" do |rmagick|
end

Cutter::Stamper.scope :vips => "ruby-vips" do |rmagick|
end
