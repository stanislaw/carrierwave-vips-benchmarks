# carrierwave-vips-benchmarks

This repo demonstrates the performance of ruby-vips, the Ruby binding for
the libvips library, when used with the ```CarrierWave``` file uploader
plugin for Ruby on Rails framework.  There is similar repository,
[vips-benchmarks](https://github.com/stanislaw/vips-benchmarks), which
focuses on the advantages ruby-vips has over other image processing libraries.
This repo is intended to show, how these advantages spread to Rails
territory.  

This benchmark uses the
[CarrierWave::Vips](https://github.com/eltiare/carrierwave/commit/08bc69f379b25d413a6243e6545defe2a88b45f0)
module written by [Jeremy Nicoll](https://github.com/eltiare/),
other participants are modules which are currently used in
[carrierwave](https://github.com/jnicklas/carrierwave) master
branch. Actually, ```CarrierWave::ImageScience``` module code had been [cut
out](https://github.com/jnicklas/carrierwave/commit/8b85d793d62cbce1115185b0dde51ce4e3cac6f4)
of carrierwave's master a year ago because of lack of maintenance, but it
is in here among the others.

OK, let's see.

## Status (June 30, 2012)

Repo is in setup phase:

* Test procedure can be significantly changed
* New participants might be added
* Whatever

## Participants

* [ruby-vips](https://github.com/jcupitt/ruby-vips)
* [rmagick](http://rmagick.rubyforge.org/)
* [mini_magick](https://github.com/probablycorey/mini_magick)
* [image_science](https://github.com/seattlerb/image_science)

## Results

```text
Linux localhost 3.3.0-gentoo #6 SMP Sat Mar 24 20:32:13 EET 2012 i686 
Intel(R) Core(TM) i3 CPU M 370 @ 2.40GHz GenuineIntel GNU/Linux

This is RMagick 2.13.1 ($Date: 2009/12/20 02:33:33 $) Copyright (C) 2009 by 
Timothy P. Hunter
Built with ImageMagick 6.7.7-5 2012-06-24 Q16 http://www.imagemagick.org
Built for ruby 1.9.3
Web page: http://rmagick.rubyforge.org
Email: rmagick@rubyforge.org

Image Science 1.2.3

Ruby-vips 0.2.0 built against vips-7.26.7-Tue May 22 02:54:27 EEST 2012

-- create_table(:users, {:force=>true})
   -> 0.0336s

#<File:samples/peacock.jpg>

ruby-vips
---------
   4371ms

RMagick
-------
 7382ms

mini_magick
-----------
     16759ms

Image Science
-------------
       9166ms

Vips peak memuse in kb: 176336
RMagick peak memuse in kb: 144176
MiniMagick peak memuse in kb: 120912
ImageScience peak memuse in kb: 136800
```

Timing results are made using [cutter](https://github.com/stanislaw/cutter) gem.

## Code

### Procedure

A similar procedure is run using each uploader. Each uploader is being
run in its own file. The following output is concatenated for readability:

```ruby
# setup/settings.rb

NUMBER = 100

def image
  File.open('samples/peacock.jpg')
end

# ./runner-rmagick.rb
NUMBER.times do
  u = User.new :name => 'Stanislaw'
  u.rmagick_avatar = image
  u.save!
end

# ./runner-mini-magick.rb
NUMBER.times do
  u = User.new :name => 'Stanislaw'
  u.mini_magick_avatar = image
  u.save!
end

# ./runner-image-science.rb
NUMBER.times do
  u = User.new :name => 'Stanislaw'
  u.image_science_avatar = image
  u.save!
end

# ./runner-vips.rb
NUMBER.times do
  u = User.new :name => 'Stanislaw'
  u.vips_avatar = image
  u.save!
end
```

### Database setup

```ruby
require 'active_record'

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
```

### Uploaders

All uploaders, beside uploading original file, have 3 versions to
generate. Let's take one of them for example:

```ruby
# encoding: utf-8

class RMagickUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # include CarrierWave::Uploader::Processing
  # include CarrierWave::Vips

  version :rtlimit do
    process :resize_to_limit => [100, 100]
  end

  version :rtfit do
    process :resize_to_fit => [100, 100]
  end
  
  version :rtfill do
    process :resize_to_fill => [100, 100]
  end

  # Other stuff
end
```

### User model:

```ruby
require 'app/uploaders/rmagick_uploader'
require 'app/uploaders/mini_magick_uploader'
require 'app/uploaders/image_science_uploader'
require 'app/uploaders/vips_uploader'

class User < ActiveRecord::Base
  mount_uploader :rmagick_avatar, RMagickUploader
  mount_uploader :mini_magick_avatar, MiniMagickUploader
  mount_uploader :image_science_avatar, ImageScienceUploader
  mount_uploader :vips_avatar, VipsUploader
end
```

## Do it yourself

Run ```bundle```

Runner running all sub-runners:

```bash
$ ./runner
# or just
$ rake
```

Runners for each of libraries:

```bash
$ ./runner-vips
$ ./runner-rmagick
$ ./runner-mini-magick
$ ./runner-image-science
```

## Feedback

Feedback is appreciated!

## Copyright
Copyright (c) 2012 Stanislaw Pankevich
