require '../../header.rb'

parcelData = {}
landUseData = {}

Dir.glob('../get/prcl*.html') do |prclFile|
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

Dir.glob('../get/land*.html') do |landFile|
  htmlBlob = File.open(landFile).read
  html = Nokogiri::HTML(htmlBlob)
  once = true
  html.xpath('//div[@class="record-slider"]/table').each do |record|
    lincNO = record.xpath('@id').text().match(/.*_(.*)/)[1]
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
    landUseData[lincNO] = landUse
  end
end

shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

headers = ['Address','PID','Property LINC','Roll Number','Tax Year','Assessment Value','Description','Legal Description','Land Use District Code','Land Use Description','subdivision','street_number','route','locality','administrative_area_level_1','administrative_area_level_2','country','postal_code','latitude','longitude']

CSV($stdout, headers: headers, write_headers: true) do |out|
  (shardStart..shardEnd).each do |i|
    pageNo = i+1
    filename = "../get/asmt#{pageNo}.html"
    if File.exist?(filename)
      htmlBlob = File.open(filename).read
      html = Nokogiri::HTML(htmlBlob)
      html.xpath('//div[@class="record-slider"]/table').each do |record|
        out << CSV::Row.new(headers, []).tap do |row|
          record.xpath('tr').each do |col|
            prop = col.xpath('td')
            colName = prop[0].xpath('a').text()
            colValue = prop[2].text()
            row[colName] = colValue
          end
          row['subdivision'] = 'Spruce Grove'
          row['Legal Description'] = parcelData[row['Roll Number']]
          row['Land Use District Code'] = landUseData[row['Property LINC'][0]]
          row['Land Use Description'] = landUseData[row['Property LINC'][1]]
          unless row['Address'] == nil
            query = row['Address'] + 'Spruce Grove, Canada'
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
end
