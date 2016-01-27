require '../../header.rb'

shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

baseUrl = "curl 'http://col.lloydminster.ca/colmap/Result/resultFromQuery.aspx' -H 'Cookie: __utmt=1; __utma=35906045.105102501.1452375670.1452907454.1453876121.5; __utmb=35906045.1.10.1453876121; __utmc=35906045; __utmz=35906045.1452907454.4.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); ASP.NET_SessionId=wm5o0vq3nr3pu15iqffycsde; iVAULTMapguideAuth=CC46A9D7AC5D65D810445F6DEC0244E3D8B50EADDCC4CD80AC2A4BCBB73F24A47C1D215CCDF0C16D2E53AF17B4EAFC7A3E6DBA137EDB0F3E9DABC47D9BCE432C40DF63BA087724E800E36210AEAF8637E7713BB0046B17DE898F5F97A5AB81A4E8A4C3930551E7C8A880C89E4BA76A9168132F4268E0D59691D10362546228E9C680CDB828419A4251A610B546BCD51B; PHPSESSID=3118433a-c4bf-11e5-8000-000c29b2b490-en-MTI3LjAuMC4x0AF20AF10AF0' -H 'Origin: http://col.lloydminster.ca' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://col.lloydminster.ca/colmap/' --data 'fields=%5B%7B%22name%22%3A%22STREETADDRESS%22%2C%22fieldId%22%3A661%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_7%22%2C%22selectControlId%22%3A%22sel0.9357824390754104%22%2C%22tabIndex%22%3A6%2C%22value%22%3A%22%22%7D%5D&config=%7B%22currentPage%22%3A"
endUrl = "%2C%22totalResults%22%3A-1%2C%22menuId%22%3A63%7D&mgSessionId=3118433a-c4bf-11e5-8000-000c29b2b490_en_MTI3LjAuMC4x0AF20AF10AF0&mapName=Overall_201256a863a13795d&_method=put' --compressed -s"

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
