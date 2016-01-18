require '../../header.rb'

shardIdx = ARGV[1].to_i
shardSize = ARGV[2].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1
pullType = ARGV[0].to_s

baseUrlAsmt = "curl 'http://maps.sprucegrove.org/public/result/ChangePageOrSorting.aspx' -H 'Cookie: ASP.NET_SessionId=vyqscdou533kxl35aynot5fi; iVAULTMapguideAuth=54750455AAED9C256852663BDC50242481F6F04181CA42FF68522F21B351771252C67153DDC5716234BB3793FD7ADFE0E9FD00F093F8EA027AFD4375170414328298A18A8871E1429A5E1D4CF7BD074C0E9085D8B96CDEEFCAEC643A77E87951D45ED8CADD172B0224BFD667BF7B896B851E37173C53E4AB415597D8FB9132D64DF219A5D301409076DF99AEBA6AA3F2; PHPSESSID=744287d2-bdb8-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'config=%7B%22menuId%22%3A56%2C%22currentPage%22%3A"
endUrlAsmt = "%2C%22totalResults%22%3A15088%7D&dbObjectId=15&customFolderName=CoSG&mgSessionId=744287d2-bdb8-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public569c99cfa84ce' --compressed -s"
baseUrlPrcl = "curl 'http://maps.sprucegrove.org/public/result/ChangePageOrSorting.aspx' -H 'Cookie: ASP.NET_SessionId=be1bqvhnr1cy5pxmre5r0exv; iVAULTMapguideAuth=B3BC02579E67DB515B4301ECB970F63472E09BE6C9D0823A202A18743668B8BF2A9F308DFAAB1F02DCD2B523B6E05A305A74AE40B31864824FE7D2CD73A832C91F54F46E761F37FB9B2E6B21E48D8ECC914D9A7120E0E04896E68692946B9BE73CA36E6BAAF33C7910720C1F36A4D84C99035239A70A8F1ACE248F9828488AA4880D04613C6BAB6676E4189EA77F6A44; PHPSESSID=8f91335e-bdb7-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'config=%7B%22menuId%22%3A51%2C%22currentPage%22%3A"
endUrlPrcl = "%2C%22totalResults%22%3A14559%7D&dbObjectId=12&customFolderName=CoSG&mgSessionId=8f91335e-bdb7-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public569c9850831fe' --compressed -s"
baseUrlLand = "curl 'http://maps.sprucegrove.org/public/result/ChangePageOrSorting.aspx' -H 'Cookie: ASP.NET_SessionId=eq10ncqtwqipg2z35tqqzois; iVAULTMapguideAuth=D5F0A7309E5F554BB0D89AF58E26D1C2B818C2C3D3B3ABA5ECDDB0EEE8BCEEF2161A8618F19A75A0C209D4B2C9962DFA445E4232BD34C565C02671C71861E6C76143EC9B9970533C1B4D0D883A1C63C2611F0044529ED6005333F64E5CEC5293026947AB5B2CE6555D85634C1A830B05901129341545C7C0E2DE183690390D0340945023D34BE28A98B1AFB11BC0A784; PHPSESSID=0cf48fa8-bdb8-11e5-8000-005056b842ed-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://maps.sprucegrove.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'X-Prototype-Version: 1.7' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.sprucegrove.org/public/Default.aspx' --data 'config=%7B%22menuId%22%3A51%2C%22currentPage%22%3A"
endUrlLand = "%2C%22totalResults%22%3A12261%7D&dbObjectId=20&customFolderName=CoSG&mgSessionId=0cf48fa8-bdb8-11e5-8000-005056b842ed_en_MTI3LjAuMC4x0AFC0AFB0AFA&mapName=CoSG_Public569c991fcab29' --compressed -s"
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
  json = nil
  json = JSON.parse(response)
  ap "Saved: #{pullType}#{pageNo}.html"
  File.open("#{pullType}#{pageNo}.html", "wb") do |file|
    file.write(json['html'])
  end
end
