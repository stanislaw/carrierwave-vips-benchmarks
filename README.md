# carrierwave-vips-benchmarks

This repo demonstrates performance of ruby-vips, Ruby bindings for
libvips library, working behind ```CarrierWave``` file uploader plugin for
Ruby on Rails framework. There is similar repository: [vips-benchmarks](https://github.com/stanislaw/vips-benchmarks), which focuses on advantage ruby-vips has over other image processing libraries. This repo is intended to show, how this advantages spread on Rails territory. From the ruby-vips side this benchmark relies on implementation of [CarrierWave::Vips](https://github.com/eltiare/carrierwave/commit/08bc69f379b25d413a6243e6545defe2a88b45f0) module written by [Jeremy Nicoll](https://github.com/eltiare/), other participants are modules which are currently used in [carrierwave](https://github.com/jnicklas/carrierwave) master branch. Actually, ```CarrierWave::ImageScience``` module code had been cut out of carrierwave's master a year ago because of lack of maintaining, but it is in here among the others. OK, let's see.

## Status (June 30, 2012)

Repo is in setup phase:

* Test procedure can be changed
* New participants might be added
* Whatever

## Participants

* [ruby-vips](https://github.com/jcupitt/ruby-vips)
* [rmagick](http://rmagick.rubyforge.org/)
* [mini_magick](https://github.com/probablycorey/mini_magick)
* [image_science](https://github.com/seattlerb/image_science)

## Results first

```text

```

## Procedure

```ruby
n = 200
n.times do
  u = User.new :name => 'first'
  u.rmagick_avatar = image
  u.save!
end

n.times do
  u = User.new :name => 'first'
  u.mini_magick_avatar = image
  u.save!
end

n.times do
  u = User.new :name => 'first'
  u.image_science_avatar = image
  u.save!
end

n.times do
  u = User.new :name => 'first'
  u.vips_avatar = image
  u.save!
end
```

## Feedback

Feedback is appreciated!
