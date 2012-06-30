require 'app/uploaders/rmagick_uploader'
require 'app/uploaders/mini_magick_uploader'
require 'app/uploaders/image_science_uploader'
require 'app/uploaders/vips_uploader'

class User < ActiveRecord::Base
  validates :name, :presence => true

  mount_uploader :rmagick_avatar, RMagickUploader
  mount_uploader :mini_magick_avatar, MiniMagickUploader
  mount_uploader :image_science_avatar, ImageScienceUploader
  mount_uploader :vips_avatar, VipsUploader
end

