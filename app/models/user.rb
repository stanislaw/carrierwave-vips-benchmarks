require 'app/uploaders/magick_uploader'
require 'app/uploaders/vips_uploader'

class User < ActiveRecord::Base
  validates :name, :presence => true

  mount_uploader :magick_avatar, MagickUploader
  mount_uploader :vips_avatar, VipsUploader
end

