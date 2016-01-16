require '../../header.rb'

API_KEY = 'AIzaSyD0kGtJ5C0sgtRF312cBSg0mVjIfd2yE4o'
shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

headers = ['roll','legal','address','land_area','land_area_unit','subdivision','zoning','market_land_site_area','market_land_site_area_unit','year_of_assessment','assessment_value','street_number','route','locality','administrative_area_level_1','administrative_area_level_2','country','postal_code','latitude','longitude']

############################################################
# Geocode Address
def get_response(query)
  query = query + 'Morinville Canada'
  encoded_query = CGI.escape(query)
  response = JSON.parse(open("https://maps.googleapis.com/maps/api/geocode/json?address=#{encoded_query}&key=#{API_KEY}").read)
  result = response['results'][0]

  street_number = nil
  route = nil
  locality = nil
  administrative_area_level_1 = nil
  administrative_area_level_2 = nil
  country = nil
  postal_code = nil
  latitude = nil
  longitude = nil

  unless result.nil?
    unless result['address_components'].nil?
      result['address_components'].each do |component|
        if component['types'][0] == 'street_number'
          street_number = component['long_name']
        elsif component['types'][0] == 'route'
          route = component['long_name']
        elsif component['types'][0] == 'locality'
          locality = component['long_name']
        elsif component['types'][0] == 'administrative_area_level_1'
          administrative_area_level_1 = component['long_name']
        elsif component['types'][0] == 'administrative_area_level_2'
          administrative_area_level_2 = component['long_name']
        elsif component['types'][0] == 'country'
          country = component['long_name']
        elsif component['types'][0] == 'postal_code'
          postal_code = component['long_name']
        end
      end
    end
    latitude = result['geometry']['location']['lat']
    longitude = result['geometry']['location']['lng']
  end

  {
    street_number: street_number,
    route: route,
    locality: locality,
    administrative_area_level_1: administrative_area_level_1,
    administrative_area_level_2: administrative_area_level_2,
    country: country,
    postal_code: postal_code,
    latitude: latitude,
    longitude: longitude
  }

end
############################################################

CSV($stdout, headers: headers, write_headers: true) do |out|
  (shardStart..shardEnd).each do |i|
    idx = i.to_s.rjust(9, '0')
    filename = "#{idx}.pdf.txt"
    if File.exist?(filename)
    # filename = "321081830.pdf.txt"
      textBlob =File.open(filename).read
      textBlob.gsub!(/\r\n?/, "\n")
      out << CSV::Row.new(headers, []).tap do |row|
        row['roll'] = textBlob.match(/Roll: (\d*)/)[1]
        row['legal'] = textBlob.match(/Legal: (.*) Address/)[1]
        row['address'] = textBlob.match(/Address: (.*)\n/)[1]
        row['land_area'] = textBlob.match(/Land Area: (\d*\.?\d*)/)[1]
        row['land_area_unit'] = 'Acres'
        row['subdivision'] = 'Town of Morinville'
        row['zoning'] = textBlob.match(/Zoning: (.*)/)[1]
        row['market_land_site_area'] = textBlob.match(/Site Area: (\d*\.?\d*)/)[1]
        row['market_land_site_area_unit'] = 'Acres'
        row['year_of_assessment'] = '2014'
        row['assessment_value'] = '12,321,3215'
        response = get_response(row['address'])
        sleep 0.3
        row['street_number'] = response[:street_number]
        row['route'] = response[:route]
        row['locality'] = response[:locality]
        row['administrative_area_level_1'] = response[:administrative_area_level_1]
        row['administrative_area_level_2'] = response[:administrative_area_level_2]
        row['country'] = response[:country]
        row['postal_code'] = response[:postal_code]
        row['latitude'] = response[:latitude]
        row['longitude'] = response[:longitude]
      end
    end
  end
end
