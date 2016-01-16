require '../../header.rb'

shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

baseUrl = 'https://maps.sturgeoncounty.ca/content/assessment_reports/2014/'
endUrl = '2014_110.PDF'

(shardStart..shardEnd).each do |i|
  idx = i.to_s.rjust(9, '0')
  url = "#{baseUrl}#{idx}#{endUrl}"
  begin
    pdfFile = open(url)
    ap "Saved: #{idx}.pdf"
    File.open("#{idx}.pdf", "wb") do |file|
      file.write(pdfFile.read)
    end
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      STDERR.puts "File: #{idx}.pdf not found"
    else
      raise e
    end
  end
end
