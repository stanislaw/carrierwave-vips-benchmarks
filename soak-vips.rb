#!/usr/bin/env ruby

# soak-test carrierwave-vips
#
# make the test images like this:
#
# cd carrierwave-vips-benchmarks/samples
# mkdir soak
# cd soak
# for i in {0..2000}; do cp ../peacock.jpg $i.jpg; done
#
# ie. make 2000 copies of peacock.jpg under different names -- we need 2,000
# separate files to make sure we defeat vips's caching system

$:.unshift File.dirname __FILE__

require 'setup/requires'

i = 0
Dir.foreach("samples/soak") do |filename|
    # we run for "." etc. 
    next if filename !~ /.jpg$/

    print "loop #{i} "
    Procedure.run :vips, image("samples/soak/#{filename}"), 1

    i += 1
end

