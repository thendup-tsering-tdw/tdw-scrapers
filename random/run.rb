require 'awesome_print'
require 'mechanize'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'CSV'

$maxNumber = 10
url = "curl 'http://www.alabamagis.com/Bullock/CamaTemplates/Reports/SearchResults.CFM' -H 'Cookie: CFID=1491616; CFTOKEN=76191621; PHPSESSID=7744db3c-6ad4-11e6-8000-001e679e2c6d-en-MTI3LjAuMC4x0AFC0AFB0AFA' -H 'Origin: http://www.alabamagis.com' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://www.alabamagis.com/Bullock/CamaTemplates/Reports/SearchSearch.cfm' -H 'Connection: keep-alive' --data 'MaxRecords=#{$maxNumber}&Master__Account=&Master__Map1=&Master__Map2=&Master__Map3=&Master__Map4=&Master__Map5=&Master__Map6=&Master__Map7=&Master__Map8=&Master__Map9=&Master__Map10=&Master__Map11=&Master__Map12=&Master__Map13=&Master__Map14=&Master__OWNER=&Parcel_Name_Operator=BEGINS_WITH&Master_Street_No=&Master_Street_Name=&Master__BillZip=&Master__Great_Acres=&Master__Less_Acres=&Master__Great_Apr_Value=&Master__Less_Apr_Value=&Master__District=11&Master__UseCode=&Master__ExmptCode=&Master__SubName=&Parcel_Subd_text=&Parcel_Subd_Operator=BEGINS_WITH&Master__Deed_Book=&Master__Deed_Page=&Master__DDate_Great=&Master__DDate_Less=&Master__Section=&Master__Township=&Master__Range=&submit=Search' --compressed -s"

response = `#{url}`
xml = Nokogiri::HTML(response)
ap xml.xpath('html/body/form/table/tr[3]/td[5]').children[0].text
