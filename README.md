# carrierwave-vips-benchmarks

This repo aims to demonstrate the performance of ruby-vips, the Ruby
binding for the libvips library, when used with the ```CarrierWave``` file
uploader plugin for Ruby on Rails framework.  

There is similar repository,
[vips-benchmarks](https://github.com/stanislaw/vips-benchmarks), which
focuses on the advantages ruby-vips has over other image processing libraries.
This repo is intended to show, how these advantages spread to Rails territory.

This benchmark uses the
[CarrierWave::Vips](https://github.com/eltiare/carrierwave/commit/08bc69f379b25d413a6243e6545defe2a88b45f0)
module written by [Jeremy Nicoll](https://github.com/eltiare/),
other participants are modules which are currently used in
[carrierwave](https://github.com/jnicklas/carrierwave) master
branch. Actually, ```CarrierWave::ImageScience``` module code had been [cut
out](https://github.com/jnicklas/carrierwave/commit/8b85d793d62cbce1115185b0dde51ce4e3cac6f4)
of carrierwave's master a year ago because of lack of maintenance, but it
is in here among the others.

## Status (July 3, 2012)

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
removing previous files uploaded by carrierwave...
Linux kiwi 3.2.0-26-generic #41-Ubuntu SMP Thu Jun 14 17:49:24 UTC 2012 x86_64
x86_64 x86_64 GNU/Linux

This is RMagick 2.13.1 ($Date: 2009/12/20 02:33:33 $) Copyright (C) 2009 by
Timothy P. Hunter
Built with ImageMagick 6.6.9-7 2012-04-30 Q16 http://www.imagemagick.org
Built for ruby 1.8.7
Web page: http://rmagick.rubyforge.org
Email: rmagick@rubyforge.org

MiniMagick 3.4

Image Science 1.2.3

Ruby-vips 0.2.0 built against libvips 7.29.0-Sun Jul  1 11:08:59 BST 2012

Timing (fastest wall-clock time of 3 runs):
ruby-vips, jpeg image: 59ms
ruby-vips, png image: 3122ms
rmagick, jpeg image: 185ms
rmagick, png image: 9602ms
mini_magick, jpeg image: 339ms
mini_magick, png image: 10243ms
image_science, jpeg image: 241ms
image_science, png image: 6470ms
Peak memuse (max of sum of mmap and brk, including sub-processes):
vips ... 60 MB
rmagick ... 199 MB
mini-magick ... 49 MB
image-science ... 149 MB
```

Memory use is measured by watching strace output
for brk and mmap calls, see Tim Starling's [blog
post](http://tstarling.com/blog/2010/06/measuring-memory-usage-with-strace).

## Analysis

We've timed for a 1024 x 768 JPEG image and a 5120 x 3840 PNG image.

JPEG images can be shrunk very quickly by subsampling during load, so we
wanted to include a PNG as well to stress the memory systems on these
libraries a little more.

MiniMagick does all processing in a forked
`mogrify` command, so its direct memory use for image processing is zero.
Looking at `top`, mogrify is is using about 150mb on my laptop.

If we take MiniMagick as zero, vips is using about 21mb of ram, rmagick about
150mb and ImageScience about 100mb.

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
require 'benchmark'

def image src
  File.open src
end

module Procedure
  NUMBER = 1

  class << self
    def run processor, img, best_of
      result = nil

      capture_stdout do
        result = Benchmark.bmbm do |b|
          (1 .. best_of).each do |number|
            b.report number.to_s do
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
