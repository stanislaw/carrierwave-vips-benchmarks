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

MiniMagick 3.4

Image Science 1.2.3

Ruby-vips 0.2.0 built against vips-7.26.7-Tue May 22 02:54:27 EEST 2012

ruby-vips, jpeg image: 357ms
rmagick, jpeg image: 695ms
mini_magick, jpeg image: 1702ms
image_science, jpeg image: 824ms

Vips peak memuse in kb: 141328
RMagick peak memuse in kb: 143792
MiniMagick peak memuse in kb: 122224
ImageScience peak memuse in kb: 137552
```

Memory use is measured with `/usr/bin/time -f %M`, in other words, it's the
peak RSS of the starting process. MiniMagick does all processing in a forked
`mogrify` command, so its direct memory use for image processing is zero.

If we take MiniMagick as zero, vips is using about 19mb of ram, rmagick about
21mb and ImageScience about 15mb, so all essentially equal. We are assuming
that Ruby's GC is running about equally in these four cases.

The default test is for many iterations of a small JPEG image. If we try a
single iteration of a large PNG image instead we see different behaviour (N=100):

```text
$ vips replicate peacock.jpg peacock.png 15 15
```

Repeats the test JPEG image 15 times in each axis to make a 9,000 x 7,000 RGB 
PNG image.

```text
removing previous files uploaded by carrierwave...
Linux kiwi 3.2.0-26-generic #41-Ubuntu SMP Thu Jun 14 17:49:24 UTC
2012 x86_64 x86_64 x86_64 GNU/Linux

This is RMagick 2.13.1 ($Date: 2009/12/20 02:33:33 $) Copyright (C)
2009 by Timothy P. Hunter
Built with ImageMagick 6.6.9-7 2012-04-30 Q16 http://www.imagemagick.org
Built for ruby 1.8.7
Web page: http://rmagick.rubyforge.org
Email: rmagick@rubyforge.org

Image Science 1.2.3

Ruby-vips 0.2.0 built against vips-7.29.0-Sun Jul  1 11:08:59 BST 2012

ruby-vips
---------
   6918ms

RMagick
-------
37002ms

mini_magick
-----------
    37158ms

Image Science
-------------
      20190ms

Vips peak memuse in kb: 385440
RMagick peak memuse in kb: 757728
MiniMagick peak memuse in kb: 364272
ImageScience peak memuse in kb: 1665488
```

Now taking MiniMagick as zero again gives us 21mb for vips, 394mb for rmagick
and 1.3gb for ImageScience.

Vips memory use scales with image width (it has to keep a few hundred scan
lines of the image in memory at once as it streams it through the system),
RMagick scales with image size (it loads the entire image into memory) and 
ImageScience scales by size and complexity of processing (it seems to lack
RMagick's system for destroying intermediate images quickly). 

## Code

### Procedure

A similar procedure is run using each uploader. Each uploader is being
run in its own file.

```ruby
# setup/procedure.rb

module Procedure
  NUMBER = 10

  class << self
    def run processor, img
      result = nil

      capture_stdout do
        result = Benchmark.bmbm do |b|
          (1..5).each do |number|
            b.report number do
              NUMBER.times do
                u = User.new :name => 'first'
                u.send :"#{processor}_avatar=", img
                u.save!
              end
            end
          end
        end
      end

      output result
    end

    def output result
      result = (result.map(&:to_a).map{|el| el[5]}.min * 1000).to_i
      puts "#{result}ms"
    end
  end
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

Besides uploading original file, each uploader has 3 versions to
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
