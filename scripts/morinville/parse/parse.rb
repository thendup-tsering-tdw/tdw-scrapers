require '../../header.rb'

shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

headers = ['roll','legal','address','land_area','land_area_unit','subdivision','zoning','market_land_site_area','market_land_site_area_unit','year_of_assessment','assessment_value','street_number','route','locality','administrative_area_level_1','administrative_area_level_2','country','postal_code','latitude','longitude']

CSV($stdout, headers: headers, write_headers: true) do |out|
  (shardStart..shardEnd).each do |i|
    idx = i.to_s.rjust(9, '0')
    filename = "#{idx}.pdf.txt"
    if File.exist?(filename)
    # filename = "321081830.pdf.txt"
      textBlob =File.open(filename).read
      textBlob.gsub!(/\r\n?/, "\n")
      out << CSV::Row.new(headers, []).tap do |row|
        row['roll'] = textBlob.match(/Roll: (\d*)/)[1] unless textBlob.match(/Roll: (\d*)/) == nil
        row['legal'] = textBlob.match(/Legal: (.*) Address/)[1] unless textBlob.match(/Legal: (.*) Address/) == nil
        row['address'] = textBlob.match(/Address: (.*)\n/)[1] unless textBlob.match(/Address: (.*)\n/) == nil
        row['land_area'] = textBlob.match(/Land Area: (\d*\.?\d*)/)[1] unless textBlob.match(/Land Area: (\d*\.?\d*)/) == nil
        row['land_area_unit'] = 'Acres'
        row['subdivision'] = 'Town of Morinville'
        row['zoning'] = textBlob.match(/Zoning: (.*)/)[1] unless textBlob.match(/Zoning: (.*)/) == nil
        row['market_land_site_area'] = textBlob.match(/Site Area: (\d*\.?\d*)/)[1] unless textBlob.match(/Site Area: (\d*\.?\d*)/) == nil
        row['market_land_site_area_unit'] = 'Acres'
        row['year_of_assessment'] = '2014'
        # row['assessment_value'] =
        unless row['address'] == nil
          query = row['address'] + 'Morinville, Canada'
          response = get_response(query)
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
end
