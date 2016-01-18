require '../../header.rb'

shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

baseUrl = "curl 'http://col.lloydminster.ca/colmap/result/ChangePageOrSorting.aspx' -H 'Cookie: __utma=35906045.105102501.1452375670.1452788515.1452907454.4; __utmz=35906045.1452907454.4.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); ASP.NET_SessionId=1q0jntpnqvex1u0ygankg5xq; iVAULTMapguideAuth=9314C0DAB7C3D2226B99764A0B2DBF9EEED0E05566D4D2B4589FD5A7D1C4ECA1B2801DBD820A274FF81000378997673AA5142814F2FE7507975D35BED14EEA78DEBA8866F228021E1716D68B767F870E920C90126BE43A980C4E2E9F4840A98A51BDAE9CEF90EE31390F1AC0D221B7AB2DCD45236CD6256008898DB9E2222FB316E2285298F6D3B6E4CD6C854B099CE5; PHPSESSID=cb5e4732-bd7b-11e5-8000-000c29b2b490-en-MTI3LjAuMC4x0AF20AF10AF0' -H 'Origin: http://col.lloydminster.ca' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://col.lloydminster.ca/colmap/' --data 'config=%7B%22menuId%22%3A63%2C%22currentPage%22%3A"
endUrl = "%2C%22totalResults%22%3A12500%7D&dbObjectId=32&customFolderName=Lloydminster&mgSessionId=cb5e4732-bd7b-11e5-8000-000c29b2b490_en_MTI3LjAuMC4x0AF20AF10AF0&mapName=Overall_2012569c3408a13fd' --compressed -s"

(shardStart..shardEnd).each do |i|
  i = i+1;
  pageNo = i.to_s
  command = "#{baseUrl}#{pageNo}#{endUrl}"
  response = `#{command}`
  sleep 0.3
  json = JSON.parse(response)
  ap "Saved: #{pageNo}.html"
  File.open("#{pageNo}.html", "wb") do |file|
    file.write(json['html'])
  end
end
