require '../../header.rb'

a = Mechanize.new
loginUrl = 'http://maps.morinville.ca/Morinville/logon.aspx'
curlBaseUrl = "curl 'http://maps.morinville.ca/Morinville/Webservice/Search.svc/RollNum' -H 'Cookie: ASP.NET_SessionId=3mylleq5li5mrcgtsqczhda3; _auth=635911416000673360%26d10dd0a4a2e6f3a5902c4a222666c079; .AUTH_forms=A161CB707A6950B02475CB1DF06D4AECB03BB3E621CBA2147E2F75FD81F212CC05A895D28491374AE90333935600CC663D3B5CC1EE2BC631DE4876ACE6B351F0DC4A06C67DF5CF4F07B050CFE37DB1AB1EC3065526F79DAA2CC152DDB564AB9D7A3180B70AE24208BF0A314184A57D4285A15DF0E41955650239FF31D69A8DFED4CC9920B43C1AF94459A70AEB3D3013' -H 'Origin: http://maps.morinville.ca' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'auth_code: d10dd0a4a2e6f3a5902c4a222666c079' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36' -H 'Content-Type: application/json' -H 'Accept: */*' -H 'auth_account: $public$' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Referer: http://maps.morinville.ca/Morinville/Views/SearchResult.htm' -H 'auth_seed: 635911416000673360' --data-binary '"
curlEndUrl = "' --compressed -s"
baseDataBinary = '{"RollNum":"'
endDataBinary = '","buffer":"","mapName":"Morinville"}'
lincData = {}

# Need to convert pdfs to txts before continuing
ap "Converting all pdf files to txt format"
`for file in ../../../1pulled/morinville/*.pdf; do pdftotext "$file" "$file.txt"; done`

a.get(loginUrl) do |page|
  login_page = a.click(page.link_with(:text => /Click here to enter the Public Site/))
  Dir.glob("#{$pulledDir}/morinville/*.txt") do |txtFile|
    textBlob = File.open(txtFile).read
    textBlob.gsub!(/\r\n?/, "\n")
    rollNo = textBlob.match(/Roll: (\d*)/)[1] unless textBlob.match(/Roll: (\d*)/) == nil
    command = "#{curlBaseUrl}#{baseDataBinary}#{rollNo}#{endDataBinary}#{curlEndUrl}"
    response = `#{command}`
    json = JSON.parse(response)
    if json == nil
      ap "No data found for Roll Number: #{rollNo}"
    else
      if json != nil
        if json['d'] != nil
          if json['d']['Result'] != nil
            if json['d']['Result'][0] != nil
              json['d']['Result'][0].each do |record|
                if record['Key'] == 'lincnumber'
                  ap "Found LINC number for Roll: #{rollNo}"
                  lincData[rollNo] = record['Value']
                  sleep 0.3
                end
              end
            end
          end
        end
      end
    end
  end
  File.open("#{$pulledDir}/morinville/lincData.json", "wb") do |file|
    ap "File Saved: lincData.json"
    file.write(lincData.to_json)
  end
end
