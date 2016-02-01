require '../../header.rb'

headers = ['FID','Area (m)','area_unit','Roll #','Lot-Blk-Plan','Legal','Lot','Block','Plan','HOUSE #','HOUSEHALF','Street Name','St. Address','LOTBLKPLN','Roll # (Short)','subdivision','street_number','route','locality','administrative_area_level_1','administrative_area_level_2','country','postal_code','latitude','longitude']

CSV($stdout, headers: headers, write_headers: true) do |out|
  Dir.glob("#{$pulledDir}/lloydminster/*.html") do |htmlFile|
    htmlBlob = File.open(htmlFile).read
    html = Nokogiri::HTML(htmlBlob)
    html.xpath('//div[@class="record-slider"]/table').each do |record|
      out << CSV::Row.new(headers, []).tap do |row|
        record.xpath('tr').each do |col|
          prop = col.xpath('td')
          colName = prop[0].xpath('a').text()
          colValue = prop[2].text()
          row[colName] = colValue
        end
        row['area_unit'] = 'Metres'
        row['subdivision'] = 'City of Lloydminster'
        unless row['St. Address'] == nil
          query = row['St. Address'] + ' Lloydminster, Canada'
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
end
