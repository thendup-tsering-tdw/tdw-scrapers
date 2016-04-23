require '../../header.rb'

parcelData = {}
landUseData = {}

Dir.glob("#{$pulledDir}/spruce/prcl*.html") do |prclFile|
  htmlBlob = File.open(prclFile).read
  html = Nokogiri::HTML(htmlBlob)
  html.xpath('//div[@class="record-slider"]/table').each do |record|
    rollNo = record.xpath('@id').text().match(/.*_(.*)/)[1]
    legalDesc = ''
    record.xpath('tr').each do |col|
      prop = col.xpath('td')
      colName = prop[0].xpath('a').text()
      if colName == 'Legal Description'
        legalDesc = prop[2].text().to_s
      end
    end
    parcelData[rollNo] = legalDesc
  end
end

Dir.glob("#{$pulledDir}/spruce/land*.html") do |landFile|
  htmlBlob = File.open(landFile).read
  html = Nokogiri::HTML(htmlBlob)
  once = true
  html.xpath('//div[@class="record-slider"]/table').each do |record|
    pid = record.xpath('@id').text().match(/.*_(.*)/)[1]
    landUse = []
    landCode = ''
    landDesc = ''
    record.xpath('tr').each do |col|
      prop = col.xpath('td')
      colName = prop[0].xpath('a').text()
      if colName == 'Land Use District Code'
        landCode = prop[2].text().to_s
      elsif colName == 'Description'
        landDesc = prop[2].text().to_s
      end
    end
    landUse = [landCode,landDesc]
    landUseData[pid] = landUse
  end
end


headers = ['address','pid','property_linc','roll_number','tax_year','assessment_value','description','legal_description','land_use_district_code','land_use_description','subdivision','street_number','route','locality','administrative_area_level_1','administrative_area_level_2','country','postal_code','latitude','longitude']

CSV($stdout, headers: headers, write_headers: true) do |out|
  Dir.glob("#{$pulledDir}/spruce/asmt*.html") do |asmtFile|
    htmlBlob = File.open(asmtFile).read
    html = Nokogiri::HTML(htmlBlob)
    html.xpath('//div[@class="record-slider"]/table').each do |record|
      out << CSV::Row.new(headers, []).tap do |row|
        record.xpath('tr').each do |col|
          prop = col.xpath('td')
          colName = prop[0].xpath('a').text().underscore
          colValue = prop[2].text()
          row[colName] = colValue
        end
        row['subdivision'] = 'Spruce Grove'
        row['legal_description'] = parcelData[row['roll_number']]
        if landUseData[row['pid']] != nil
          row['land_use_district_code'] = landUseData[row['pid']][0]
          row['land_use_description'] = landUseData[row['pid']][1]
        end
        unless row['address'] == nil
          query = row['address'] + ' Spruce Grove, Canada'
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
