require '../../header.rb'

lincData = {}
Dir.glob("#{$pulledDir}/morinville/lincData.json") do |jsonFile|
  jsonBlob = File.open(jsonFile).read
  lincData = JSON.parse(jsonBlob)
end

headers = ['roll','legal','address','land_area','land_area_unit','subdivision','zoning','linc_number','market_land_site_area','market_land_site_area_unit','year_of_assessment','assessment_value','street_number','route','locality','administrative_area_level_1','administrative_area_level_2','country','postal_code','latitude','longitude']

CSV($stdout, headers: headers, write_headers: true) do |out|
  Dir.glob("#{$pulledDir}/morinville/*.txt") do |txtFile|
    textBlob = File.open(txtFile).read
    textBlob.gsub!(/\r\n?/, "\n")
    reverseBlob = textBlob.split.reverse.join(' ')
    assessmentVal = reverseBlob.match(/\s((\d*,?)*)\s/)[1]
    out << CSV::Row.new(headers, []).tap do |row|
      row['roll'] = textBlob.match(/Roll: (\d*)/)[1] unless textBlob.match(/Roll: (\d*)/) == nil
      row['legal'] = textBlob.match(/Legal: (.*) Address/)[1] unless textBlob.match(/Legal: (.*) Address/) == nil
      row['address'] = textBlob.match(/Address: (.*)\n/)[1] unless textBlob.match(/Address: (.*)\n/) == nil
      row['land_area'] = textBlob.match(/Land Area: (\d*\.?\d*)/)[1] unless textBlob.match(/Land Area: (\d*\.?\d*)/) == nil
      row['land_area_unit'] = 'Acres'
      row['subdivision'] = 'Town of Morinville'
      row['zoning'] = textBlob.match(/Zoning: (.*)/)[1] unless textBlob.match(/Zoning: (.*)/) == nil
      row['linc_number'] = lincData[row['roll']]
      row['market_land_site_area'] = textBlob.match(/Site Area: (\d*\.?\d*)/)[1] unless textBlob.match(/Site Area: (\d*\.?\d*)/) == nil
      row['market_land_site_area_unit'] = 'Acres'
      row['year_of_assessment'] = '2014'
      row['assessment_value'] = assessmentVal
      unless row['address'] == nil
        query = row['address'] + ' Morinville, Canada'
        response = get_response(query)
        sleep 0.3
        if response == nil
          STDERR.puts "Gecoding Error, skipping address: #{query}"
        else
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
end
