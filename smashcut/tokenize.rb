timer_start = Time.now


def tokenize (fountain)
  src = Array.new
  fountain.each do |line|
    src.push(line)
  end

  tokens = Array.new

  src.each do |line|
    if line =~ /\n/
      tokens.push(line)
    end
  end

  return tokens
end


filename = ARGV.first

screenplay = File.open(filename)
puts "\nGlancing over #{filename}."


puts tokenize(screenplay)


puts "Tokenized in %.2f seconds.\n\n" % (Time.now - timer_start)
screenplay.close()
