require '../../header.rb'

shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

a = Mechanize.new
loginUrl = 'http://maps.morinville.ca/Morinville/logon.aspx'
baseUrl = 'http://maps.morinville.ca/Morinville/Views/SearchExport.aspx?type=Report&REPORTTYPE=221&FILEPATH='
endUrl = '2014_110.PDF&mapName=Morinville'

a.get(loginUrl) do |page|
  # Click the login link
  login_page = a.click(page.link_with(:text => /Click here to enter the Public Site/))
  (shardStart..shardEnd).each do |i|
    idx = i.to_s.rjust(9, '0')
    url = "#{baseUrl}#{idx}#{endUrl}"
    a.get(url) do |pdfFile|
      if pdfFile.body.match(/Failed to download file using the specified path/)
        STDERR.puts "File: #{idx}.pdf not found"
      else
        ap "Saved: #{idx}.pdf"
        File.open("#{idx}.pdf", "wb") do |file|
          file.write(pdfFile.body)
        end
      end
    end
  end
end
