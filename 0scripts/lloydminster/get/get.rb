require '../../header.rb'

shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

baseUrl = "curl 'http://col.lloydminster.ca/colmap/Result/resultFromQuery.aspx' -H 'Cookie: __utma=35906045.105102501.1452375670.1453876121.1454263027.6; __utmz=35906045.1452907454.4.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); ASP.NET_SessionId=jlglgic5zsvx3ogb4udzqlgy; iVAULTMapguideAuth=3F84A5E924633908388E7DC0CDD008B2AB4EC5E6FB9BEEB0A14518CB5CF4885F2546EB8B85B9F0CA9464F2D397F84922D17D1D86FBFED5E65C34659EF477A0057099FD1033FC3B481C17776F162B30A6EE1DA8194DDFFA0B9B2EF807104A9AD040C960685759B2A559B27A74872D5E1CF124D5FE86A7A6F54F5F1DCE05F16B25DB55159A9C0EDF585B569FEC6618AE4B; PHPSESSID=1c1e0fee-c926-11e5-8000-000c29b2b490-en-MTI3LjAuMC4x0AF20AF10AF0' -H 'Origin: http://col.lloydminster.ca' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.97 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://col.lloydminster.ca/colmap/' --data 'fields=%5B%7B%22name%22%3A%22STREETADDRESS%22%2C%22fieldId%22%3A661%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_7%22%2C%22selectControlId%22%3A%22sel0.06593906320631504%22%2C%22tabIndex%22%3A6%2C%22value%22%3A%22%22%7D%5D&config=%7B%22currentPage%22%3A"
endUrl = "%2C%22totalResults%22%3A-1%2C%22menuId%22%3A63%7D&mgSessionId=1c1e0fee-c926-11e5-8000-000c29b2b490_en_MTI3LjAuMC4x0AF20AF10AF0&mapName=Overall_201256afc63e96ccc&_method=put' --compressed -s"

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
    File.open("#{$pulledDir}/lloydminster/#{pageNo}.html", "wb") do |file|
      file.write(json['html'])
    end
  end
end
