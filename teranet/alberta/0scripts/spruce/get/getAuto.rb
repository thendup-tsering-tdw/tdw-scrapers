require '../../header.rb'

shardIdx = ARGV[1].to_i
shardSize = ARGV[2].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1
pullType = ARGV[0].to_s

# baseUrlAsmt = "curl 'http://maps.sprucegrove.org/public/Result/resultFromQuery.aspx' -H 'Cookie: __utma=237542367.213277545.1452372924.1452372924.1452789792.2; __utmz=237542367.1452372924.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); ASP.NET_SessionId=gmux1ey15ydr3dsfn40jrx5e; iVAULTMapguideAuth=47D77A531A03637024D08B99E47633B0A24C34391B1A1E34FF8CB3A2DFEA950AEF4A48A9E90F8D751EBEF4EC6E0B824E2471E64C99627D1AF7474708094EC25ACFE5322565C3EA797228A160BF563599551E31EA7CD2885EBBD73FB5DB891F0E0F11BC4C6E9B6CCD8B6DC93F688B8CFA49B5F38731D12BC332499B34E2FE377BA98827B02157AA0DC86924B703A4B949; PHPSESSID=def53d8c-c4bf-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'fields=%5B%7B%22name%22%3A%22StreetName%22%2C%22fieldId%22%3A281%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_25%22%2C%22selectControlId%22%3A%22sel0.3965278761461377%22%2C%22tabIndex%22%3A25%2C%22value%22%3A%22%22%7D%2C%7B%22name%22%3A%22StreetNumber%22%2C%22fieldId%22%3A280%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_31%22%2C%22selectControlId%22%3A%22sel0.2102061149198562%22%2C%22tabIndex%22%3A31%2C%22value%22%3A%22%22%7D%2C%7B%22name%22%3A%22UnitNumber%22%2C%22fieldId%22%3A282%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_37%22%2C%22selectControlId%22%3A%22sel0.10665019182488322%22%2C%22tabIndex%22%3A37%2C%22value%22%3A%22%22%7D%5D&config=%7B%22currentPage%22%3A"
# endUrlAsmt = "%2C%22totalResults%22%3A-1%2C%22menuId%22%3A56%7D&mgSessionId=def53d8c-c4bf-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public56a864bc36129&_method=put' --compressed -s"
# baseUrlPrcl = "curl 'http://maps.sprucegrove.org/public/Result/resultFromQuery.aspx' -H 'Cookie: __utma=237542367.213277545.1452372924.1452372924.1452789792.2; __utmz=237542367.1452372924.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); ASP.NET_SessionId=gmux1ey15ydr3dsfn40jrx5e; iVAULTMapguideAuth=47D77A531A03637024D08B99E47633B0A24C34391B1A1E34FF8CB3A2DFEA950AEF4A48A9E90F8D751EBEF4EC6E0B824E2471E64C99627D1AF7474708094EC25ACFE5322565C3EA797228A160BF563599551E31EA7CD2885EBBD73FB5DB891F0E0F11BC4C6E9B6CCD8B6DC93F688B8CFA49B5F38731D12BC332499B34E2FE377BA98827B02157AA0DC86924B703A4B949; PHPSESSID=def53d8c-c4bf-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'fields=%5B%7B%22name%22%3A%22StreetName%22%2C%22fieldId%22%3A183%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_7%22%2C%22selectControlId%22%3A%22sel0.05490713124163449%22%2C%22tabIndex%22%3A6%2C%22value%22%3A%22%22%7D%2C%7B%22name%22%3A%22StreetNumber%22%2C%22fieldId%22%3A182%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_13%22%2C%22selectControlId%22%3A%22sel0.02364906040020287%22%2C%22tabIndex%22%3A12%2C%22value%22%3A%22%22%7D%2C%7B%22name%22%3A%22UnitNumber%22%2C%22fieldId%22%3A263%2C%22dataType%22%3A%22Text%22%2C%22operatorList%22%3A%5Bnull%2Cnull%2Cnull%2Cnull%5D%2C%22operator%22%3A%221%22%2C%22id%22%3A%22anonymous_element_19%22%2C%22selectControlId%22%3A%22sel0.1697516015265137%22%2C%22tabIndex%22%3A18%2C%22value%22%3A%22%22%7D%5D&config=%7B%22currentPage%22%3A"
# endUrlPrcl = "%2C%22totalResults%22%3A-1%2C%22menuId%22%3A51%7D&mgSessionId=def53d8c-c4bf-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public56a864bc36129&_method=put' --compressed -s"

sessionIdUrl = "; iVAULTMapguideAuth="

baseUrlAsmt = "curl 'http://maps.sprucegrove.org/public/result/ChangePageOrSorting.aspx' -H 'Cookie: ASP.NET_SessionId="
midUrlAsmt = "; PHPSESSID=744287d2-bdb8-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'config=%7B%22menuId%22%3A56%2C%22currentPage%22%3A"
endUrlAsmt = "%2C%22totalResults%22%3A15088%7D&dbObjectId=15&customFolderName=CoSG&mgSessionId=744287d2-bdb8-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public569c99cfa84ce' --compressed -s"

baseUrlPrcl = "curl 'http://maps.sprucegrove.org/public/result/ChangePageOrSorting.aspx' -H 'Cookie: ASP.NET_SessionId="
midUrlPrcl = "; PHPSESSID=8f91335e-bdb7-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'config=%7B%22menuId%22%3A51%2C%22currentPage%22%3A"
endUrlPrcl = "%2C%22totalResults%22%3A14559%7D&dbObjectId=12&customFolderName=CoSG&mgSessionId=8f91335e-bdb7-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public569c9850831fe' --compressed -s"

baseUrlLand = "curl 'http://maps.sprucegrove.org/public/result/ChangePageOrSorting.aspx' -H 'Cookie: ASP.NET_SessionId="
midUrlLand = "; PHPSESSID=0cf48fa8-bdb8-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'config=%7B%22menuId%22%3A51%2C%22currentPage%22%3A"
endUrlLand = "%2C%22totalResults%22%3A12261%7D&dbObjectId=20&customFolderName=CoSG&mgSessionId=0cf48fa8-bdb8-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public569c991fcab29' --compressed -s"

pullTypes = {}
pullTypes['asmt']=[baseUrlAsmt,midUrlAsmt,endUrlAsmt]
pullTypes['prcl']=[baseUrlPrcl,midUrlPrcl,endUrlPrcl]
pullTypes['land']=[baseUrlLand,midUrlLand,endUrlLand]

baseUrl = pullTypes[pullType][0]
midUrl = pullTypes[pullType][1]
endUrl = pullTypes[pullType][2]

a = Mechanize.new
loginUrl = 'http://maps.sprucegrove.org/public/Default.aspx'

a.get(loginUrl) do |loginPage|
  form = loginPage.forms[0]
  button = form.button_with(:name => "btnSubmit")
  form.action = 'http://maps.sprucegrove.org/public/Default.aspx'
  homePage = form.submit()
  sessionId = nil
  mapGuideAuth = nil
  a.cookies.each do |cookie|
    if cookie.name == 'ASP.NET_SessionId'
      sessionId = cookie.value
    end
    if cookie.name == 'iVAULTMapguideAuth'
      mapGuideAuth = cookie.value
    end
  end
  searchForm = homePage.forms[0]
  objectIdField = searchForm.field_with(name: "objectId")
  objectIdField.value = 12
  # fieldsField = searchForm.field_with(name: "fields")
  # fieldsFields.value = '[{"name":"StreetName","fieldId":183,"dataType":"Text","operatorList":[null,null,null,null],"operator":"1","id":"anonymous_element_7","selectControlId":"sel0.15245333104394376","tabIndex":6,"value":""},{"name":"StreetNumber","fieldId":182,"dataType":"Text","operatorList":[null,null,null,null],"operator":"1","id":"anonymous_element_13","selectControlId":"sel0.880449612159282","tabIndex":12,"value":""},{"name":"UnitNumber","fieldId":263,"dataType":"Text","operatorList":[null,null,null,null],"operator":"1","id":"anonymous_element_19","selectControlId":"sel0.5083394553512335","tabIndex":18,"value":""}]'
  mapNameField = searchForm.field_with(name: "mapName")
  mapNameField.value = 'CoSG_Public56a936f347383'
  results = searchForm.submit

  # (shardStart..shardEnd).each do |i|
  #   i = i+1;
  #   pageNo = i.to_s
  #   command = "#{baseUrl}#{sessionId}#{sessionIdUrl}#{mapGuideAuth}#{midUrl}#{pageNo}#{endUrl}"
  #   response = `#{command}`
  #   ap command
  #   # sleep 0.3
  #   # json = JSON.parse(response)
  #   # ap "Saved: #{pullType}#{pageNo}.html"
  #   # File.open("#{$pulledDir}/spruce/#{pullType}#{pageNo}.html", "wb") do |file|
  #   #   file.write(json['html'])
  #   # end
  # end
end
