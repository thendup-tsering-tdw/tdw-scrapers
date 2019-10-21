require 'json'
require 'awesome_print'
require 'csv'

locations = JSON.parse(File.read('geo2.json'))

allJSON = []
locations.each do |location|
	baseURL = "curl 'http://rl.mcdonalds.com/googleapps/GoogleSearchUSAction.do?method=searchLocation&searchTxtLatlng=("
	lat = location["latitude"]
	comma = "%2C"
	long = location["longitude"]
	endURL = ")&actionType=searchRestaurant&language=en&country=ca' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.80 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: */*' -H 'Referer: http://rl.mcdonalds.com/googleapps/GoogleSearchUSAction.do?method=googlesearchLocation&primaryCity=&postalCode=&country=ca&language=en&src=www.mcdonalds.ca?method=googlesearchLocation&primaryCity=K7H&postalCode=&country=ca&language=en&src=www.mcdonalds.ca' -H 'Cookie: JSESSIONID=BC1EF72440B24D4D3F87A28CB46C83C4.node23; AWSELB=0D03D9B514F40D93273E59218FE1764E57B2F16A8D8C9A4C968FDE8E6670F5D6A16E6D44151C5A30B0EE7A48D2F076F973DFB5906B3D0F6A727C1591F15AF1322FCF2AC845E48B71190601422353B53B6A04C6E34D' -H 'Connection: keep-alive' --compressed -s"
	command = "#{baseURL}#{lat}#{comma}#{long}#{endURL}"
	result = `#{command}`
	json = JSON.parse(result)
	allJSON = allJSON + json["results"]
	STDERR.puts "Pulled for #{location['address']}"
end

headers = ['company','store_id','phone_number','store_type','monday_open','monday_close','tuesday_open','tuesday_close','wednesday_open','wednesday_close','thursday_open','thursday_close','friday_open','friday_close','saturday_open','saturday_close','sunday_open','sunday_close','address','city','province','lat','long','geometry']
allJSON.each do |branch|
	  CSV($stdout, headers: headers, write_headers: true) do |out|
			out << CSV::Row.new(headers, []).tap do |row|
				row['company'] = 'McDonalds'
				row["store_id"] = branch["entityid"]
				row['phone_number'] = branch['telephone']
				addrString = branch['addresses'][0]['address']
				if addrString.match(/<h3>(.*)<\/h3>/) != nil
					row['address'] = addrString.match(/<h3>(.*)<\/h3>/)[1]
				end
				if addrString.match(/<\/h3>(\w*)\s\w*/) != nil
					row['city'] = addrString.match(/<\/h3>(\w*)\s\w*/)[1]
				end
				if addrString.match(/<\/h3>\w*\s(\w*)/) != nil
					row['province'] = addrString.match(/<\/h3>\w*\s(\w*)/)[1]
				end
				row['lat'] = branch['latitude']
				row['long'] = branch['longitude']
				row['geometry'] = "{\"type\": \"Point\", \"coordinates\": [#{branch['latitude']}, #{branch['longitude']}]}"
				row['store_type_2'] = branch['storeType']
				if branch['timeings'] != nil
					if branch['timeings'][0] != nil
						if branch['timeings'][0]['openTime'] != nil
							row['monday_open'] = branch['timeings'][0]['openTime']
						end
						if branch['timeings'][0]['closeTime'] != nil
							row['monday_close'] = branch['timeings'][0]['closeTime']
						end
					end
					if branch['timeings'][1] != nil
						if branch['timeings'][1]['openTime'] != nil
							row['tuesday_open'] = branch['timeings'][1]['openTime']
						end
						if branch['timeings'][1]['closeTime'] != nil
							row['tuesday_close'] = branch['timeings'][1]['closeTime']
						end
					end
					if branch['timeings'][2] != nil
						if branch['timeings'][2]['openTime'] != nil
							row['wednesday_open'] = branch['timeings'][2]['openTime']
						end
						if branch['timeings'][2]['closeTime'] != nil
							row['wednesday_close'] = branch['timeings'][2]['closeTime']
						end
					end
					if branch['timeings'][3] != nil
						if branch['timeings'][3]['openTime'] != nil
							row['thursday_open'] = branch['timeings'][3]['openTime']
						end
						if branch['timeings'][3]['closeTime'] != nil
							row['thursday_close'] = branch['timeings'][3]['closeTime']
						end
					end
					if branch['timeings'][4] != nil
						if branch['timeings'][4]['openTime'] != nil
							row['friday_open'] = branch['timeings'][4]['openTime']
						end
						if branch['timeings'][4]['closeTime'] != nil
							row['friday_close'] = branch['timeings'][4]['closeTime']
						end
					end
					if branch['timeings'][5] != nil
						if branch['timeings'][5]['openTime'] != nil
							row['saturday_open'] = branch['timeings'][5]['openTime']
						end
						if branch['timeings'][5]['closeTime'] != nil
							row['saturday_close'] = branch['timeings'][5]['closeTime']
						end
					end
					if branch['timeings'][6] != nil
						if branch['timeings'][6]['openTime'] != nil
							row['sunday_open'] = branch['timeings'][6]['openTime']
						end
						if branch['timeings'][6]['closeTime'] != nil
							row['sunday_close'] = branch['timeings'][6]['closeTime']
						end
					end
				end
			end
	  end
end
