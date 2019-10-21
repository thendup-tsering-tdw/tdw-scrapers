require 'csv'
require 'awesome_print'
require 'rgeo/geo_json'

oldFile = ARGV[0].to_s
newFile = ARGV[1].to_s

csv = CSV.parse(File.open(oldFile), {headers: true})
CSV.open(newFile, "w", write_headers: true, headers: csv.headers) do |outCsv|
  csv.each do |row|
    oldGeo = row['geometry']
    newGeo = RGeo::GeoJSON.decode(oldGeo, json_parser: :json).as_text
    # ap oldGeo
    # ap newGeo
    row['geometry'] = newGeo
    outCsv << row
  end
end
