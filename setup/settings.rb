NUMBER = 100

def image
  @image ||= File.open('samples/peacock.jpg')
end

puts "\n"
puts image.inspect
puts "\n"
