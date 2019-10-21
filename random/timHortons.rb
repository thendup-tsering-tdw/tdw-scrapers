require 'json'
require 'awesome_print'
require 'csv'
require 'nokogiri'

locations = JSON.parse(File.read('ca_postal_codes.json'))

allXML = []
locations.each do |location|
	# baseURL = "curl 'http://www.timhortons.com/ca/en/php/getRestaurants.php?origlat="
	# lat = location["latitude"]
	# comma = "&origlng="
	# long = location["longitude"]
	# endURL = "&units=km&rad=100&_=1450126565245' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.80 Safari/537.36' -H 'Accept: */*' -H 'Referer: http://www.timhortons.com/ca/en/locations/locations.php?q_loc=K7H&q_rad=100' -H 'X-Requested-With: XMLHttpRequest' -H 'Cookie: PHPSESSID=qag2r2effufauaukkklepg2i04; AWSELB=B92F6F7D1EF3E46A4ABB4C2542242304097BABB5F80AC86E42045E058A97F96CD11429C777D2C354AE40D85723015860BB1C885005B6CFDFD1E080B934D21013071807A4BD; __utmt=1; __utma=88875934.789902466.1447689700.1447689700.1450126098.2; __utmb=88875934.3.10.1450126098; __utmc=88875934; __utmz=88875934.1450126098.2.2.utmgclid=CPr4xdac3MkCFYM8aQodZBgCcQ|utmccn=(not%20set)|utmcmd=(not%20set)|utmctr=(not%20provided)' -H 'Connection: keep-alive' -H 'Cache-Control: no-cache' --compressed -s"
	# command = "#{baseURL}#{lat}#{comma}#{long}#{endURL}"
	# result = `#{command}`
	# xml = Nokogiri::XML(result)
	# allXML = allXML.push(xml)
	puts location["place_name"]
end
#
# headers = ['company','store_id','phone_number','store_type','monday_open','monday_close','tuesday_open','tuesday_close','wednesday_open','wednesday_close','thursday_open','thursday_close','friday_open','friday_close','saturday_open','saturday_close','sunday_open','sunday_close','address','city','province','lat','long']
# allXML.each do |markersInSinglePC| #<markers>...</markers>
# 	  CSV($stdout, headers: headers, write_headers: true) do |out|
# 			CSV::Row.new(headers, []).tap do |row|
# 				markersInSinglePC.xpath('//markers/marker').each do |marker| #<marker.../>
# 					# ap marker.xpath('@storeid').text()
# 					puts marker
# 					puts
# 				end
# 			end
# 	  end
# end
