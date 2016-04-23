require '../../header.rb'

shardIdx = ARGV[1].to_i
shardSize = ARGV[2].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1
pullType = ARGV[0].to_s

baseUrlAsmt = "curl 'http://maps.sprucegrove.org/public/Result/resultFromQuery.aspx' -H 'Cookie: __utma=237542367.213277545.1452372924.1452372924.1452789792.2; __utmz=237542367.1452372924.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); ASP.NET_SessionId=mfjsececbr4fii0cvbrgvgrz; iVAULTMapguideAuth=D2A1F76FA6622E84B2EE50AA611854CC5A7CDD378866427F963D643007ADEDE94BC23A38C24D0C1581533C91F61751BC3B4BC50BF7ADB0DD056523B99CBB87605520168FF5ED103AEFA9A6FC2B0BA725D7EBDAD3296BB734309CAE202E4725C54031CC9595ED778AC5DA08766644B588C0D424C88B3B87C6F2D1D67BFF7AA8FB39A44BC4461BBA6B83E5EA26751C6036; PHPSESSID=9b696568-c846-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.97 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'fields=%5B%7B%22name%22%3A%22StreetName%22%2C%22fieldId%22%3A281%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_43%22%2C%22selectControlId%22%3A%22sel0.3774713734164834%22%2C%22tabIndex%22%3A44%2C%22value%22%3A%22%22%7D%2C%7B%22name%22%3A%22StreetNumber%22%2C%22fieldId%22%3A280%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_49%22%2C%22selectControlId%22%3A%22sel0.5647355983965099%22%2C%22tabIndex%22%3A50%2C%22value%22%3A%22%22%7D%2C%7B%22name%22%3A%22UnitNumber%22%2C%22fieldId%22%3A282%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_55%22%2C%22selectControlId%22%3A%22sel0.3051695488393307%22%2C%22tabIndex%22%3A56%2C%22value%22%3A%22%22%7D%5D&config=%7B%22currentPage%22%3A"
endUrlAsmt = "%2C%22totalResults%22%3A-1%2C%22menuId%22%3A56%7D&mgSessionId=9b696568-c846-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public56ae4f4656917&_method=put' --compressed -s"

baseUrlPrcl = "curl 'http://maps.sprucegrove.org/public/Result/resultFromQuery.aspx' -H 'Cookie: __utma=237542367.213277545.1452372924.1452372924.1452789792.2; __utmz=237542367.1452372924.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); ASP.NET_SessionId=mfjsececbr4fii0cvbrgvgrz; iVAULTMapguideAuth=7985C9E88300217B199842C9BBE7FE2C9C03654ED9E59F7296AE5CA2CC72215AD284392CB4183BF4E55AC7BE333594E7E9869C55D650230F65EA41D4B2BC759E232CB2B96348E8A8BF6E8B501F09A9EAA98A0FDEFA7624BA84F38B5608FF93DF3697E5445C584E9FE087B4D0FFF0146C4C1CB893A05CA32EF7D8183BFB32EB19EF38D2366F497DF12CB8E6B6DD985AA8; PHPSESSID=9b696568-c846-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.97 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'fields=%5B%7B%22name%22%3A%22StreetName%22%2C%22fieldId%22%3A183%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_61%22%2C%22selectControlId%22%3A%22sel0.699587072012946%22%2C%22tabIndex%22%3A63%2C%22value%22%3A%22%22%7D%2C%7B%22name%22%3A%22StreetNumber%22%2C%22fieldId%22%3A182%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_67%22%2C%22selectControlId%22%3A%22sel0.9414129911456257%22%2C%22tabIndex%22%3A69%2C%22value%22%3A%22%22%7D%2C%7B%22name%22%3A%22UnitNumber%22%2C%22fieldId%22%3A263%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_73%22%2C%22selectControlId%22%3A%22sel0.5533765454310924%22%2C%22tabIndex%22%3A75%2C%22value%22%3A%22%22%7D%5D&config=%7B%22currentPage%22%3A"
endUrlPrcl = "%2C%22totalResults%22%3A-1%2C%22menuId%22%3A51%7D&mgSessionId=9b696568-c846-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public56ae4f4656917&_method=put' --compressed -s"

baseUrlLand = "curl 'http://maps.sprucegrove.org/public/result/ChangePageOrSorting.aspx' -H 'Cookie: __utma=237542367.213277545.1452372924.1452372924.1452789792.2; __utmz=237542367.1452372924.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); ASP.NET_SessionId=nz4atmdvzvloxnspjwt05lqk; iVAULTMapguideAuth=25284E9CA04D296748013729036A1F5E0F5877DDCB4692E443A34201B45F0950C3DBA2E3D48A7A12ED078E0AC5EDD0954EA152519300B39AEEBAF32862C9F59AD4D03A986E5510114705C74DD03F0708B17165BFC3F400CDC41DAB2CEE939022C2DBBEB98FC130E059002E0967E3E37EAA922AE36F98E5FF144ADB032DFD0F14A37F0AA8AC647B73E50E5ED86641FAB9; PHPSESSID=48fe4c3a-d534-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'config=%7B%22menuId%22%3A51%2C%22currentPage%22%3A"
endUrlLand = "%2C%22totalResults%22%3A12391%7D&dbObjectId=20&customFolderName=CoSG&mgSessionId=48fe4c3a-d534-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public56c4000075508' --compressed -s"

pullTypes = {}
pullTypes['asmt']=[baseUrlAsmt,endUrlAsmt]
pullTypes['prcl']=[baseUrlPrcl,endUrlPrcl]
pullTypes['land']=[baseUrlLand,endUrlLand]

baseUrl = pullTypes[pullType][0]
endUrl = pullTypes[pullType][1]

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
    ap "Saved: #{pullType}#{pageNo}.html"
    File.open("#{$pulledDir}/spruce/#{pullType}#{pageNo}.html", "wb") do |file|
      file.write(json['html'])
    end
  end
end
