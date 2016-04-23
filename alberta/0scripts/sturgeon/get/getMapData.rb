require '../../header.rb'

shardIdx = ARGV[0].to_i
shardSize = ARGV[1].to_i
shardStart = (shardIdx) * shardSize
shardEnd = shardStart + shardSize - 1

baseUrl = "curl 'https://maps.sturgeoncounty.ca/arcgis/rest/services/Dynamic_Public/Map_PropertyInfo/MapServer/0/queryRelatedRecords?f=json&definitionExpression=&relationshipId=0&returnGeometry=false&objectIds="
endUrl = "&outFields=*' -H 'Cookie: __utma=233050204.907258698.1454208200.1454208200.1454208200.1; __utmz=233050204.1454208200.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided)' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: */*' -H 'Referer: https://maps.sturgeoncounty.ca/Html5Viewer_2_0/Index.html?configBase=https://maps.sturgeoncounty.ca/Geocortex/Essentials/REST/sites/Property_Viewer/viewers/Property_Viewer/virtualdirectory/Resources/Config/Default' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --compressed -s"

data = {}

(shardStart..shardEnd).each do |i|
  idx = i.to_s.rjust(5, '0')
  ap "Attempting to pull for index: #{idx}"
  command = "#{baseUrl}#{idx}#{endUrl}"
  response = `#{command}`
  json = JSON.parse(response)
  if json != nil
    if json['relatedRecordGroups'] != nil
      if json['relatedRecordGroups'][0] != nil
        if json['relatedRecordGroups'][0]['relatedRecords'] != nil
          if json['relatedRecordGroups'][0]['relatedRecords'][0] != nil
            if json['relatedRecordGroups'][0]['relatedRecords'][0]['attributes'] != nil
              ap "Found data for index #{idx}"
              record = json['relatedRecordGroups'][0]['relatedRecords'][0]['attributes']
              data[record['dROLLNMBR']] = record
              fileName = record['AssessmentRpt']
              ap record
              sleep 0.3
            end
          end
        end
      end
    end
  else
    STDERR.puts "No data found for index: #{idx}"
  end
end

# Write map data to json file
ap "Writing to data.json file"
File.open("#{$pulledDir}/sturgeon/data.json", "wb") do |file|
  ap "File Saved: data.json"
  file.write(data.to_json)
end
