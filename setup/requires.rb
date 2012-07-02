$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
$:.unshift File.dirname __FILE__

require 'active_record'

require 'carrierwave'
require 'carrierwave/orm/activerecord'

require 'app/models/user'

require 'kernel'
require 'database'

require 'procedure'

system 'vips im_replicate samples/peacock.jpg samples/peacock.png 5 5' unless File.exists?('samples/peacock.png')

