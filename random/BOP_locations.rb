require 'awesome_print'
require 'mechanize'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'CSV'

agent = Mechanize.new
agent.history_added = Proc.new { sleep 0.5}
agent.log = Logger.new "mech.log"
agent.user_agent_alias = 'Mac Safari'

page = agent.get "https://www.bop.gov/locations/list.jsp"

# headers = ['address1']
# CSV($stdout, headers: headers, write_headers: true) do |out|
  page.xpath('//*[@id="OuterCol"]').css('a').map { |link|
  	href = link['href']
  	page.link_with(:href => href) do |link|
      # out << CSV::Row.new(headers, []).tap do |row|
      href = link.href
      ap link
      # url = "curl 'https://www.bop.gov/PublicInfo/execute/phyloc?todo=query&output=json&code=#{code}' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36' -H 'Accept: */*' -H 'Referer: https://www.bop.gov#{href}' -H 'X-Requested-With: XMLHttpRequest' -H 'Cookie: JSESSIONID=17A679B5C85B0D97F108373A878BB538; AWSELB=EFAFE785188A308D4C859928AC96B3912CCF95163107BBB1EED2D94F81783F3EE3975EEA0CD7F1129702E357E14F0A4048E11CAE9BE0758FAB5234B813FECE3F4BCA3692744BDA1E700FDADF8693D5645FB21F3F60; _gat_GSA_ENOR0=1; _ga=GA1.2.217999364.1468350532' -H 'Connection: keep-alive' -H 'Cache-Control: no-cache' --compressed -s"
      # response = `#{url}`
      # json = JSON.parse(response)
      # ap json
      # end
  	end
  }
# end
