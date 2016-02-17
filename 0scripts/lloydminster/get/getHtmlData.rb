require '../../header.rb'

shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

baseUrl = "http://services.lloydminster.ca/Inquiry/PropertyTax/Print/"

(shardStart..shardEnd).each do |i|
  url = "#{baseUrl}#{i}"
  begin
    htmlFile = open(url)
    ap "Saved: #{i}.html"
    File.open("#{$pulledDir}/lloydminster/print_#{i}.html", "wb") do |file|
      file.write(htmlFile.read)
    end
    sleep 0.3
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      STDERR.puts "File: print_#{i}.html not found"
    elsif e.message == '500 Internal Server Error'
      STDERR.puts "500: Server Error on index: #{i}"
    else
      raise e
    end
  end
end
