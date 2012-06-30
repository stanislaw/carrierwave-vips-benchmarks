require 'require_all'
require 'cutter'

require 'active_record'

require 'carrierwave'
require 'carrierwave/orm/activerecord'

require 'app/models/user'

$:.unshift File.dirname __FILE__

require 'database'
require 'output'
require 'settings'
