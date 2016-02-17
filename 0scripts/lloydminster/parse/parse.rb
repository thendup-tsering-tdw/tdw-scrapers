require '../../header.rb'

headers = ['fid','area','area_unit','roll_number','lot_blk_plan','assessment_value','legal','lot','block','plan','house_number','house_half','street_name','street_address','lot_blk_plan_code','short_roll_number','subdivision','street_number','route','locality','administrative_area_level_1','administrative_area_level_2','country','postal_code','latitude','longitude']

assessmentData = {}

Dir.glob("#{$pulledDir}/lloydminster/roll_*.html") do |htmlFile|
  htmlBlob = File.open(htmlFile).read
  html = Nokogiri::HTML(htmlBlob)
  html.xpath('//div[@id="content"]/table').each do |record|
    assessmentData[record.xpath('//tr[3]/td').text()] = record.xpath('//tr[8]/td').text()
  end
end

CSV($stdout, headers: headers, write_headers: true) do |out|
  Dir.glob("#{$pulledDir}/lloydminster/page_*.html") do |htmlFile|
    htmlBlob = File.open(htmlFile).read
    html = Nokogiri::HTML(htmlBlob)
    html.xpath('//div[@class="record-slider"]/table').each do |record|
      out << CSV::Row.new(headers, []).tap do |row|
        cols = record.xpath('tr')
        row['fid'] = cols[0].xpath('td')[2].text()
        row['area'] = cols[1].xpath('td')[2].text()
        row['roll_number'] = cols[2].xpath('td')[2].text()
        row['lot_blk_plan'] = cols[3].xpath('td')[2].text()
        row['assessment_value'] = assessmentData[row['lot_blk_plan']]
        row['legal'] = cols[4].xpath('td')[2].text()
        row['lot'] = cols[5].xpath('td')[2].text()
        row['block'] = cols[6].xpath('td')[2].text()
        row['plan'] = cols[7].xpath('td')[2].text()
        row['house_number'] = cols[8].xpath('td')[2].text()
        row['house_half'] = cols[9].xpath('td')[2].text()
        row['street_name'] = cols[10].xpath('td')[2].text()
        row['street_address'] = cols[11].xpath('td')[2].text()
        row['lot_blk_plan_code'] = cols[12].xpath('td')[2].text()
        row['short_roll_number'] = cols[13].xpath('td')[2].text()
        row['area_unit'] = 'Metres'
        row['subdivision'] = 'City of Lloydminster'
        unless row['street_address'] == nil
          query = row['street_address'] + ' Lloydminster, Canada'
          STDERR.puts "Gecoding: #{query}"
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
