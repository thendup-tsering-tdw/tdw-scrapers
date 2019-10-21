require 'json'
require 'awesome_print'
require 'csv'

locations = JSON.parse(File.read('ontario.json'))

allJSON = []
locations.each_with_index do |location, idx|
	baseURL = "curl 'https://openapi.starbucks.com/v1/stores/nearby?callback=&radius=250&limit=50&latLng="
	lat = location["latitude"]
	comma = "%2C"
	long = location["longitude"]
	endURL = "&ignore=storeNumber%2CownershipTypeCode%2CtimeZoneInfo%2CextendedHours&brandCodes=SBUX&access_token=eenv4bm4t6evsvqqctk8stf3&_=1455810673472' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.80 Safari/537.36' -H 'Accept: */*' -H 'Referer: http://www.starbucks.ca/store-locator/search/location/k7h' -H 'Cookie: bbbbbbbbbbbbbbb=NBAHNKHHIGMMKBGBDFOIMIKCHNBIHEHNMBMGFMMNOJLDMODNDFNPNKCPMPCABMINGKFMABOFDGCKDPJDPPJACFJEGGNAOKACCADGCAIEDFCLMJFBPFPAMJIMAIKKBLAD' -H 'Connection: keep-alive' -H 'Cache-Control: no-cache' --compressed -s"
	command = "#{baseURL}#{lat}#{comma}#{long}#{endURL}"
	result = `#{command}`
	# ap result
	json = JSON.parse(result)
	allJSON = allJSON + json["stores"]
end

headers = ['company','store_id','phone_number','operation_status','open_date','status','monday_open','monday_close','tuesday_open','tuesday_close','wednesday_open','wednesday_close','thursday_open','thursday_close','friday_open','friday_close','saturday_open','saturday_close','sunday_open','sunday_close','address','city','province','lat','long']
allJSON.each do |store|
	branch = store["store"]
  CSV($stdout, headers: headers, write_headers: true) do |out|
		out << CSV::Row.new(headers, []).tap do |row|
			row["company"] = 'Starbucks'
			row["store_id"] = branch["id"]
			row['phone_number'] = branch['phoneNumber']
			row['operation_status'] = branch['operatingStatus']['operating']
			row['status'] = branch['operatingStatus']['status']
			row['address'] = branch['address']['streetAddressLine1']
			row['lat'] = branch['coordinates']['latitude']
			row['long'] = branch['coordinates']['longitude']
			row['open_date'] = branch['operatingStatus']['openDate']
			row['city'] = branch['address']['city']
			row['province'] = branch['address']['countrySubdivisionCode']
			if branch['regularHours'] != nil
				if branch['regularHours']['monday'] != nil
					if branch['regularHours']['monday']['openTime'] != nil
						row['monday_open'] = branch['regularHours']['monday']['openTime']
					end
					if branch['regularHours']['monday']['closeTime'] != nil
						row['monday_close'] = branch['regularHours']['monday']['closeTime']
					end
				end
				if branch['regularHours']['tuesday'] != nil
					if branch['regularHours']['tuesday']['openTime'] != nil
						row['tuesday_open'] = branch['regularHours']['tuesday']['openTime']
					end
					if branch['regularHours']['tuesday']['closeTime'] != nil
						row['tuesday_close'] = branch['regularHours']['tuesday']['closeTime']
					end
				end
				if branch['regularHours']['wednesday'] != nil
					if branch['regularHours']['wednesday']['openTime'] != nil
						row['wednesday_open'] = branch['regularHours']['wednesday']['openTime']
					end
					if branch['regularHours']['wednesday']['closeTime'] != nil
						row['wednesday_close'] = branch['regularHours']['wednesday']['closeTime']
					end
				end
				if branch['regularHours']['thursday'] != nil
					if branch['regularHours']['thursday']['openTime'] != nil
						row['thursday_open'] = branch['regularHours']['thursday']['openTime']
					end
					if branch['regularHours']['thursday']['closeTime'] != nil
						row['thursday_close'] = branch['regularHours']['thursday']['closeTime']
					end
				end
				if branch['regularHours']['friday'] != nil
					if branch['regularHours']['friday']['openTime'] != nil
						row['friday_open'] = branch['regularHours']['friday']['openTime']
					end
					if branch['regularHours']['friday']['closeTime'] != nil
						row['friday_close'] = branch['regularHours']['friday']['closeTime']
					end
				end
				if branch['regularHours']['saturday'] != nil
					if branch['regularHours']['saturday']['openTime'] != nil
						row['saturday_open'] = branch['regularHours']['saturday']['openTime']
					end
					if branch['regularHours']['saturday']['closeTime'] != nil
						row['saturday_close'] = branch['regularHours']['saturday']['closeTime']
					end
				end
				if branch['regularHours']['sunday'] != nil
					if branch['regularHours']['sunday']['openTime'] != nil
						row['sunday_open'] = branch['regularHours']['sunday']['openTime']
					end
					if branch['regularHours']['sunday']['closeTime'] != nil
						row['sunday_close'] = branch['regularHours']['sunday']['closeTime']
					end
				end
			end
		end
  end
end
