require '../../header.rb'

shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

baseUrl = "curl 'http://col.lloydminster.ca/colmap/result/ChangePageOrSorting.aspx' -H 'Cookie: __utma=35906045.105102501.1452375670.1455503347.1455642811.10; __utmc=35906045; __utmz=35906045.1455503347.9.4.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); ASP.NET_SessionId=yfr4joflixjwpwsgepm1u34c; iVAULTMapguideAuth=7C41526D780586ACEE9F8898CB9D227FA89F5D74A7BE903EBDC03C00A31D874223114C1DB3E301CC2E43CDB1528FEE07C8D6A282637BA32640D7CD862E5B835D75733388B88CE0663A8218814EA3399CF871A3980D16F51118573D0BD519166397394E606CB780C6B2303F317E02A550E363348EB6E14C67DF5DF9D8C5E358D0AFEF9A527C7D91E789C11924681252E0; PHPSESSID=dc9674e2-d4f1-11e5-8000-000c29b2b490-en-MTI3LjAuMC4x0AF20AF10AF0' -H 'Origin: http://col.lloydminster.ca' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://col.lloydminster.ca/colmap/' --data 'config=%7B%22menuId%22%3A63%2C%22currentPage%22%3A"
endUrl = "%2C%22totalResults%22%3A12500%7D&dbObjectId=32&customFolderName=Lloydminster&mgSessionId=dc9674e2-d4f1-11e5-8000-000c29b2b490_en_MTI3LjAuMC4x0AF20AF10AF0&mapName=Overall_201256c3908bf04e8' --compressed -s"

(shardStart..shardEnd).each do |i|
  i = i+1;
  pageNo = i.to_s
  command = "#{baseUrl}#{pageNo}#{endUrl}"
  response = `#{command}`
  sleep 0.3
  json = JSON.parse(response)
  if json['html'] == ''
    STDERR.puts "No data on Page #{pageNo}"
  else
    ap "Saved: #{pageNo}.html"
    File.open("#{$pulledDir}/lloydminster/page_#{pageNo}.html", "wb") do |file|
      file.write(json['html'])
    end
  end
end
