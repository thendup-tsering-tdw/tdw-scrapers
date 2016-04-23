require '../../headerFiles/header.rb'

shardIdx = ARGV[1].to_i
shardSize = ARGV[2].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

url = "curl 'http://cartographie.mrclaurentides.qc.ca/gomap_web/Client/GoMapClientAgent.ashx?_dc=1461385440948' -H 'Origin: http://cartographie.mrclaurentides.qc.ca' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: */*' -H 'Referer: http://cartographie.mrclaurentides.qc.ca/sigimweb/' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data 'TARGET=SIGim&OP=GETMATINFOLIST&MATLIST=3705417045&LOCALE=FR&FORMAT=JSON&SESSIONID=8d21288a-8a13-41f0-b2ef-705a04ce41f7' --compressed -s"

# (shardStart..shardEnd).each do |i|
#   i = i+1;
#   pageNo = i.to_s
#   command = "#{url}"
#   response = `#{command}`
#   sleep 0.3
#   json = JSON.parse(response)
#   if json['html'] == ''
#     STDERR.puts "No data on Page #{pageNo}"
#   else
#     ap "Saved: #{pullType}#{pageNo}.html"
#     File.open("#{$pulledDir}/spruce/#{pullType}#{pageNo}.html", "wb") do |file|
#       file.write(json['html'])
#     end
#   end
# end

command = "#{url}"
response = `#{command}`
json = JSON.parse(response)
ap json
